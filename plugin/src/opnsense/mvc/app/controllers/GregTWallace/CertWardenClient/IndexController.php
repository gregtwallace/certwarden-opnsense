<?php
namespace GregTWallace\CertWardenClient;

class IndexController extends \OPNsense\Base\IndexController
{
    public function indexAction()
    {
        $this->view->pick('GregTWallace/CertWardenClient/index');
    }
}
