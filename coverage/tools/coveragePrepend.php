<?php
error_reporting(E_ALL & ~E_WARNING  & ~E_DEPRECATED);
ini_set('display_errors', 'On');

require_once(__DIR__."/TestCoverage.php");

TestCoverage::start();
?>
