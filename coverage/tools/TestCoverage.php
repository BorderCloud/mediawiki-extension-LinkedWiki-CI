<?php
/**
 * @copyright (c) 2021 Bordercloud.com
 * @author Karima Rafes <karima.rafes@bordercloud.com>
 * @link https://www.mediawiki.org/wiki/Extension:LinkedWiki
 * @license CC-BY-SA-4.0
 */

require_once 'coverage.php';

class TestCoverage {
        public static function start() {
                global $wgWrapper;
                $wgWrapper = new Coverage\Wrapper();
                $wgWrapper->dir = '/coverage/log/';
                $wgWrapper->start();
        }

        public static function stop() {
                global $wgWrapper;
                $wgWrapper->stop();
        }

        public static function createReportInContainer() {
                $reader = new Coverage\Reader( '/coverage/log/' );
                $filter = new Coverage\Filter();
                $filter->excludeFileRegex = '/\/yii\/.*\/framework\//';
                $merger = new Coverage\Merger();
                $converter = new Coverage\Converter();
                foreach ( $reader as $k => $data ) {
                        $data = $filter->filterData( $data );
                        $merger->mergeData( $data );
                }
                file_put_contents( '/coverage/report/clover.xml', $converter->toClover( $merger->data ) );

            // read the entire string
            $str=file_get_contents('/coverage/report/clover.xml');

            // replace path for coverage tools in Jetbrains
            //$str=str_replace("/var/www/mediawiki/", "/home/karima/git/mediawiki-extension-LinkedWiki-CI/servers/mediawiki1/",$str);
            //file_put_contents('/coverage/report/cloverFixed.xml', $str);

        }
        
        public static function createGlobalReport($prefix,$localPath,$remotePath,$excludeFileRegex,$minCoverage) {
            $source1 = './coverage/mediawiki1/log/';
            $source2 = './coverage/mediawiki2/log/';
            $destination = './coverage/log/';
                $handle = opendir( $source1 );
                while ( $file = readdir( $handle ) ) {
                        if ( substr( $file, -5 ) == '.json' ) {
                            // echo $file;
                            copy($source1.$file, $destination."m1".$file);
                        }
                }
                $handle = opendir( $source2 );
                while ( $file = readdir( $handle ) ) {
                        if ( substr( $file, -5 ) == '.json' ) {
                            // echo $file;
                            copy($source2.$file, $destination."m1".$file);
                        }
                }
        
        
                $reader = new Coverage\Reader( './coverage/log/' );
                $filter = new Coverage\Filter();
                //$filter->excludeFileRegex = '/^(?:(?!LinkedWiki\/(?!vendor|node_modules)|PushAll\/(?!vendor|node_modules)|NamespaceData\/(?!vendor|node_modules)).)*$/';
                $filter->excludeFileRegex = $excludeFileRegex;
                $merger = new Coverage\Merger();
                $converter = new Coverage\Converter();
                foreach ( $reader as $k => $data ) {
                        $data = $filter->filterData( $data );
                        $merger->mergeData( $data, $remotePath, $localPath );
                }
                file_put_contents( './coverage/report/'.$prefix.'_clover.xml', $converter->toClover( $merger->data ) );

            //read the entire string
            $str=file_get_contents('./coverage/report/'.$prefix.'_clover.xml');
            
            if ($merger->getCoveragePercent() < $minCoverage) {
                echo "The coverage is insufficient. The minimum is ".$minCoverage."%."; 
                exit(1);
            }
        }
}
