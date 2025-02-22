<?php
namespace GregTWallace\CertWardenClient;

class IndexController extends \OPNsense\Base\IndexController
{
    public function indexAction()
    {
        $this->view->settingsForm = $this->getForm("settings");
        $this->view->pick('GregTWallace/CertWardenClient/settings');
    }
}
