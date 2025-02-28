#!/usr/local/bin/php
<?php

@include_once('config.inc');
@include_once('util.inc');

use GregTWallace\CertWardenClient\Api\ServiceController;

# call the update action
$controller = new ServiceController();
$controller->updateCertActionUNSAFE();
