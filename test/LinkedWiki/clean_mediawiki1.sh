#!/usr/bin/env bash

docker cp clean_list.txt instance1.rockylinux-apache-php-mariadb-rdfunit:/tmp/clean_list.txt

echo 'cat /tmp/clean_list.txt' | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash

echo 'php /var/www/mediawiki/htdocs/w/maintenance/deleteBatch.php  --conf /var/www/mediawiki/htdocs/w/LocalSettings.php -r "clean" /tmp/clean_list.txt ; php /var/www/mediawiki/htdocs/w/maintenance/deleteOldRevisions.php --delete' | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
