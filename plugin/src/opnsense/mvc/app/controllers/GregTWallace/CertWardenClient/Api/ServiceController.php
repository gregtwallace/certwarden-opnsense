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
      $status = "failed, request wasn't POST method";
  
      if ($this->request->isPost()) {
          $status = strtolower(trim((new Backend())->configdRun('template reload GregTWallace/CertWardenClient')));
      }
  
      return ["status" => $status];
  }
}
