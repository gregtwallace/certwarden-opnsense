<?php
namespace GregTWallace\CertWardenClient\Api;

use \OPNsense\Base\ApiMutableModelControllerBase;
use \OPNsense\Core\Backend;

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
  public function connectionTestAction() {
    $status = "Failed: Request wasn't POST method.";

    if ($this->request->isPost()) {
      $status = trim((new Backend())->configdRun('certwardenclient connection_test'));
    }

    return ["status" => $status];
  }
}
