<?php
namespace GregTWallace\CertWardenClient\Api;

use \OPNsense\Base\ApiMutableModelControllerBase;
use GregTWallace\CertWardenClient\CertWardenClient;
use OPNsense\Core\Config;

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

    $certificateNode->certRefId = '';
    $cwModel->serializeToConfig(false, true);
    Config::getInstance()->save();
    Config::getInstance()->forceReload();

    return ["status" => "ok"];
  }
}
