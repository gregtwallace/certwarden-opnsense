#!/usr/local/bin/php
<?php

@include_once('config.inc');
@include_once('util.inc');

use GregTWallace\CertWardenClient\Api\ServiceController;
use OPNsense\Mvc\Request;

# call the update action
$controller = new ServiceController();

# do some wizardry to fake the POST method check
$controller->request = new Request();
$_SERVER["REQUEST_METHOD"] = 'POST';
#

$controller->updateCertAction();
