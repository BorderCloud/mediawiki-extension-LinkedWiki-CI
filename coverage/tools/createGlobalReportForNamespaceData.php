<?php

require_once(__DIR__."/TestCoverage.php");

TestCoverage::createGlobalReport(
    'NamespaceData', //prefix of report file
    realpath(dirname(__FILE__) . "/../../servers/mediawiki1/")."/", // local
    "/var/www/mediawiki/", // remote
    '/^(?:(?!NamespaceData\/(?!vendor|node_modules)).)*$/', // exclude path
    90 // min coverage
    );
 
