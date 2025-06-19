<?php

namespace GregTWallace\CertWardenClient\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\Trust\Cert;
use GregTWallace\CertWardenClient\CertWardenClient;
use OPNsense\Core\Config;
use OPNsense\Trust\Store as CertStore;

class ServiceController extends ApiMutableModelControllerBase
{
  protected static $internalModelClass = 'GregTWallace\CertWardenClient\CertWardenClient';
  protected static $internalModelName = 'certwardenclient';

  // reloadAction updates the config file
  public function reloadAction()
  {
    $status = "Failed: Request wasn't POST method.";

    if ($this->request->isPost()) {
      $status = trim((new Backend())->configdRun('template reload GregTWallace/CertWardenClient'));
    }

    return ["status" => $status];
  }

  // certwardenConnectionTestAction attempts to connect to the Cert Warden server's health endpoint
  public function connectionTestAction()
  {
    $status = "Failed: Request wasn't POST method.";

    if ($this->request->isPost()) {
      $status = trim((new Backend())->configdRun('certwardenclient connection_test'));
    }

    return ["status" => $status];
  }

  // updateCertAction attempts to fetch the certificate from Cert Warden and then update's the
  // OPNsense trust store
  public function updateCertAction()
  {
    # must be POST
    if (!$this->request->isPost()) {
      return ["status" => "Failed: Request wasn't POST method."];
    }

    # fetch cert and key
    $result = json_decode((new Backend())->configdRun('certwardenclient fetch_from_cert_warden'));
    if ($result->status !== "ok") {
      return ["status" => $result->status . ": " . $result->message];
    }

    # save cert to Trust Store
    $cert_details = CertStore::parseX509($result->certificate);
    $cert_cn      = $cert_details['commonname'];

    # If cert does not have a common name, use its first dns altname
    if ((string)$cert_cn == '') {
      $cert_cn = strtok($cert_details['altnames_dns'], "\n");
    }

    $certModel = new Cert();
    $cert = array();
    $cert['refid'] = uniqid();
    $cert['descr'] = (string)$cert_cn . ' (Cert Warden)';

    // import CW Client for checking and updating of ref
    $cwModel = new CertWardenClient();
    $certificateNode = $cwModel->getNodeByReference('certificate');

    // Check if cert was previously imported.
    $cert_found = false;
    // Otherwise just import as new cert.
    if (!empty((string)$certificateNode->certRefId)) {
      // Check if the previously imported certificate can still be found
      foreach ($certModel->cert->iterateItems() as $cfgCert) {
        // Check if IDs match
        if ((string)$certificateNode->certRefId == (string)$cfgCert->refid) {
          // Use old refid instead of generating a new one
          $cert['refid'] = (string)$cfgCert->refid;
          $cert_found = true;
          break;
        }
      }
    }

    // Check if cert was found in config
    if ($cert_found == true) {
      // Update existing cert
      foreach ($certModel->cert->iterateItems() as $cfgCert) {
        if ((string)$cfgCert->refid == $cert['refid']) {
          $cfgCert->descr = $cert['descr'];
          $cfgCert->crt = base64_encode($result->certificate);
          $cfgCert->prv = base64_encode($result->private_key);
          break;
        }
      }
    } else {
      // Create new cert
      $newcert = $certModel->cert->Add();
      foreach (array_keys($cert) as $certcfg) {
        $newcert->$certcfg = (string)$cert[$certcfg];
      }
      $newcert->crt = base64_encode($result->certificate);
      $newcert->prv = base64_encode($result->private_key);
    }

    // Update & save config
    $certificateNode->certRefId = $cert['refid'];
    $certModel->serializeToConfig(false, true);
    $cwModel->serializeToConfig(false, true);
    Config::getInstance()->save();
    Config::getInstance()->forceReload();


    // TEMP! -- TODO: add some configuration / eloquence to this
    (new Backend())->configdRun('webgui restart 3', true);


    return ["status" => "ok"];
  }
}
