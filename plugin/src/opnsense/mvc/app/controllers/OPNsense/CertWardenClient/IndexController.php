<?php
namespace OPNsense\CertWardenClient;

class IndexController extends \OPNsense\Base\IndexController
{
    public function indexAction()
    {
        $this->view->pick('OPNsense/CertWardenClient/index');
    }
}
