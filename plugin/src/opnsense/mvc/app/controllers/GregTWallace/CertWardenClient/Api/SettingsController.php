<?php
namespace GregTWallace\CertWardenClient\Api;

use \OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Config;
use OPNsense\Trust\Cert;
use GregTWallace\CertWardenClient\CertWardenClient;

class SettingsController extends ApiMutableModelControllerBase
{
  protected static $internalModelClass = 'GregTWallace\CertWardenClient\CertWardenClient';
  protected static $internalModelName = 'certwardenclient';

  // unlinkCertAction removes the cert ref id from Cert Warden Client. This is used so
  // the underlying certificate in Trust can be deleted.
  public function unlinkCertAction()
  {
    # fail if not POST
    if (!$this->request->isPost()) {
      return ["status" => "Failed: Request wasn't POST method."];
    }

    $cwModel = new CertWardenClient();
    $certificateNode = $cwModel->getNodeByReference('certificate');

    # only do something if the cert ref id isn't blank
    if (empty((string)$certificateNode->certRefId)) {
      return ["status" => "Cert Warden does not have a certificate in the Trust Store."];
    }

    # modify Trust Store description to remove reference to Cert Warden
    $certModel = new Cert();
    foreach ($certModel->cert->iterateItems() as $cfgCert) {
      if ((string)$cfgCert->refid == $certificateNode->certRefId) {
        $desc = $cfgCert->descr;
        $cwDescPosition = strrpos($desc, ' (Cert Warden)');
        $cfgCert->descr = substr($desc, 0, $cwDescPosition);;
        break;
      }
    }

    $certificateNode->certRefId = '';
    $certModel->serializeToConfig(false, true);
    $cwModel->serializeToConfig(false, true);
    Config::getInstance()->save();
    Config::getInstance()->forceReload();

    return ["status" => "ok"];
  }
}
