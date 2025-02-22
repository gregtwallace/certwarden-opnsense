<?php
namespace GregTWallace\CertWardenClient\Api;

use \OPNsense\Base\ApiMutableModelControllerBase;

class SettingsController extends ApiMutableModelControllerBase
{
  protected static $internalModelClass = 'GregTWallace\CertWardenClient\CertWardenClient';
  protected static $internalModelName = 'certwardenclient';
}
