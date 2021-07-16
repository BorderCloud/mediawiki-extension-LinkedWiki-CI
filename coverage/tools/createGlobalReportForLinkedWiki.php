<?php

require_once(__DIR__."/TestCoverage.php");

TestCoverage::createGlobalReport(
    'LinkedWiki', //prefix of report file
    realpath(dirname(__FILE__) . "/../../servers/mediawiki1/")."/", // local
    "/var/www/mediawiki/", // remote
    '/^(?:(?!LinkedWiki\/(?!vendor|node_modules)).)*$/', // exclude path
    75 // min coverage TODO improve it
    );
