<?php

require_once(__DIR__."/TestCoverage.php");
ini_set('memory_limit', '2048M');

TestCoverage::createGlobalReport(
    'PushAll', //prefix of report file
    realpath(dirname(__FILE__) . "/../../servers/mediawiki1/")."/", // local
    "/var/www/mediawiki/", // remote
    '/^(?:(?!PushAll\/(?!vendor|node_modules)).)*$/', // exclude path
    90 // min coverage
    );
