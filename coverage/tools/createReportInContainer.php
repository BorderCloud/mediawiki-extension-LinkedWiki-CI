<?php

require_once(__DIR__."/TestCoverage.php");

TestCoverage::createGlobalReport(
    'TestCoverage', //prefix of report file
    realpath(dirname(__FILE__) . "/../../servers/mediawiki1/")."/", // local
    "/var/www/mediawiki/", // remote
    '/^(?:(?!index).)*$/', // exclude path
    90 // min coverage
    );
 
