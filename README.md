[![Tests with MediaWiki 1.35](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.35.yml/badge.svg)](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.35.yml) [![Tests with MediaWiki 1.36](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.36.yml/badge.svg)](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.36.yml) [![Tests with MediaWiki 1.37](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.37.yml/badge.svg)](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.37.yml) [![Tests with MediaWiki 1.38](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.38.yml/badge.svg)](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.38.yml) [![Tests with MediaWiki 1.39](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.39.yml/badge.svg)](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.39.yml) [![Tests with MediaWiki 1.40](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.40.yml/badge.svg)](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.40.yml) [![Tests with MediaWiki 1.41](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.41.yml/badge.svg)](https://github.com/BorderCloud/mediawiki-extension-LinkedWiki-CI/actions/workflows/Test-with-MediaWiki-1.41.yml)

## mediawiki-extensions-LinkedWiki-CI
Github Actions for the [LinkedWiki extension](https://www.mediawiki.org/wiki/Extension:LinkedWiki) of MediaWiki qand its dependencies.


### How to test the LinkedWiki extension

1 - Clone this project

2 - Prepare two folders with Mediawiki (for example with the version REL1_35)
```bash
chmod +x deployMediawiki.sh
chmod +x deploy2Mediawiki.sh
#./deployMediawiki.sh REL1_39 servers/mediawiki1/htdocs 
./deployMediawiki.sh REL1_41 servers/mediawiki1/htdocs 
#./deployMediawiki.sh REL1_41 servers/mediawiki1/htdocs 
cp -R  servers/mediawiki1/htdocs/w servers/mediawiki2/htdocs/.
./deploy2Mediawiki.sh REL1_41 servers/mediawiki1/htdocs 
./deploy2Mediawiki.sh REL1_41 servers/mediawiki2/htdocs
```

3 - Start two instances of Mediawiki (one private and one public) and two RDF databases with SPARQL services
```bash
docker-compose up -d 

# docker-compose doesn't support the option --cgroupns=host for the moment
docker run --privileged --cgroupns=host -tid \
--name  instance1.rockylinux-apache-php-mariadb-rdfunit \
-h serverdev-mediawiki1.localdomain \
--network=mediawiki-extension-linkedwiki-ci_mediawiki-ci --ip=172.19.0.2 \
--add-host serverdev-mediawiki2.localdomain:172.19.0.3 \
--add-host database-test1.localdomain:172.19.0.4 \
--add-host database-test2.localdomain:172.19.0.5 \
-v "/sys/fs/cgroup:/sys/fs/cgroup:rw" \
-v "${PWD}/servers/mediawiki1:/var/www/mediawiki:ro" \
-v "${PWD}/servers/mediawiki1/vhost.conf:/etc/httpd/conf.d/vhost.conf:ro" \
-v "$PWD/config:/config:ro" \
-v "${PWD}/coverage/tools:/coverage/tools:ro" \
-v "${PWD}/coverage/mediawiki1/log:/coverage/log" \
-v "${PWD}/coverage/mediawiki1/report:/coverage/report" \
--env-file '.env' \
--env XDEBUG_CONFIG='${XDEBUG_CONFIG}' \
--env TERM='xterm' \
bordercloud/rockylinux-apache-php-mariadb-rdfunit
docker run --privileged --cgroupns=host -tid \
--name  instance2.rockylinux-apache-php-mariadb-rdfunit \
-h serverdev-mediawiki2.localdomain \
--network=mediawiki-extension-linkedwiki-ci_mediawiki-ci --ip=172.19.0.3 \
--add-host serverdev-mediawiki1.localdomain:172.19.0.2 \
--add-host database-test1.localdomain:172.19.0.4 \
--add-host database-test2.localdomain:172.19.0.5 \
-v "/sys/fs/cgroup:/sys/fs/cgroup:rw" \
-v "${PWD}/servers/mediawiki2:/var/www/mediawiki:ro" \
-v "${PWD}/servers/mediawiki2/vhost.conf:/etc/httpd/conf.d/vhost.conf:ro" \
-v "$PWD/config:/config:ro" \
-v "${PWD}/coverage/tools:/coverage/tools:ro" \
-v "${PWD}/coverage/mediawiki2/log:/coverage/log" \
-v "${PWD}/coverage/mediawiki2/report:/coverage/report" \
--env-file '.env' \
--env XDEBUG_CONFIG='${XDEBUG_CONFIG}' \
--env TERM='xterm' \
bordercloud/rockylinux-apache-php-mariadb-rdfunit


sleep 30
```

4 - Install instances of Mediawiki
```bash
cat ./mariadb_secure.sh | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
cat ./mariadb_secure.sh | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash

# mv old localsettings
mv ./servers/mediawiki1/htdocs/w/LocalSettings.php ./servers/mediawiki1/htdocs/w/LocalSettings_old.php
mv ./servers/mediawiki2/htdocs/w/LocalSettings.php ./servers/mediawiki2/htdocs/w/LocalSettings_old.php

echo 'php /var/www/mediawiki/htdocs/w/maintenance/install.php --dbname=wikidb --dbserver="localhost" --installdbuser=root --installdbpass=dockerpass --dbuser=root --dbpass=dockerpass --server="http://serverdev-mediawiki1.localdomain" --scriptpath=/w --lang=en --pass=dockerpass --skins=Vector --confpath="/tmp" "Wiki" "Admin"' | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo 'php /var/www/mediawiki/htdocs/w/maintenance/install.php --dbname=wikidb --dbserver="localhost" --installdbuser=root --installdbpass=dockerpass --dbuser=root --dbpass=dockerpass --server="http://serverdev-mediawiki2.localdomain" --scriptpath=/w --lang=en --pass=dockerpass --skins=Vector --confpath="/tmp" "Wiki" "Admin"' | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash

echo 'cat /tmp/LocalSettings.php'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash > ./servers/mediawiki1/htdocs/w/LocalSettings_generate.php 
sed -i 's/wgDefaultSkin = "vector-2022"/wgDefaultSkin = "vector"/g' ./servers/mediawiki1/htdocs/w/LocalSettings_generate.php
cat ./servers/mediawiki1/htdocs/w/LocalSettings_generate.php >> ./servers/mediawiki1/htdocs/w/LocalSettings.php
cat ./config/wiki.php >> ./servers/mediawiki1/htdocs/w/LocalSettings.php
cat ./config/wiki_private.php >> ./servers/mediawiki1/htdocs/w/LocalSettings.php
cat ./config/extensions.php >> ./servers/mediawiki1/htdocs/w/LocalSettings.php
cat ./config/linkedwiki_mediawiki1.php >> ./servers/mediawiki1/htdocs/w/LocalSettings.php

echo 'cat /tmp/LocalSettings.php'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash > ./servers/mediawiki2/htdocs/w/LocalSettings_generate.php
sed -i 's/wgDefaultSkin = "vector-2022"/wgDefaultSkin = "vector"/g' ./servers/mediawiki2/htdocs/w/LocalSettings_generate.php
cat ./servers/mediawiki2/htdocs/w/LocalSettings_generate.php >> ./servers/mediawiki2/htdocs/w/LocalSettings.php
cat ./config/wiki.php >> ./servers/mediawiki2/htdocs/w/LocalSettings.php
cat ./config/wiki_public.php >> ./servers/mediawiki2/htdocs/w/LocalSettings.php
cat ./config/extensions.php >> ./servers/mediawiki2/htdocs/w/LocalSettings.php
cat ./config/linkedwiki_mediawiki2.php >> ./servers/mediawiki2/htdocs/w/LocalSettings.php

echo "Create folder images"
echo 'cp /var/www/mediawiki/htdocs/w/images /var/www/mediawiki-images -R -p ; mkdir -p /var/www/mediawiki-images/deleted ; chown apache:apache /var/www/mediawiki-images -R' | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo 'cp /var/www/mediawiki/htdocs/w/images /var/www/mediawiki-images -R -p ; mkdir -p /var/www/mediawiki-images/deleted ; chown apache:apache /var/www/mediawiki-images -R' | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash

echo 'php /var/www/mediawiki/htdocs/w/maintenance/update.php --quick' | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo 'php /var/www/mediawiki/htdocs/w/maintenance/update.php --quick' | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash

cat ./config/sparql_grantPrivate.sql  | docker exec -i instance1.rockylinux-virtuoso7 isql 1111 dba dba
cat ./config/sparql_grantPublic.sql   | docker exec -i instance2.rockylinux-virtuoso7 isql 1111 dba dba
```

5 - Enable the coverage mode in XDebug
```bash
echo 'sed -i "s/;auto_prepend_file =/auto_prepend_file =/" /etc/php.ini && sed -i "s/;auto_append_file =/auto_append_file =/" /etc/php.ini && sed -i "s/xdebug.mode = off/xdebug.mode = coverage/" /etc/php.d/xdebug.ini && systemctl restart php-fpm && chown apache:apache /coverage/log -R && chmod -R o+r /coverage/log'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash

echo 'sed -i "s/;auto_prepend_file =/auto_prepend_file =/" /etc/php.ini && sed -i "s/;auto_append_file =/auto_append_file =/" /etc/php.ini && sed -i "s/xdebug.mode = off/xdebug.mode = coverage/" /etc/php.d/xdebug.ini && systemctl restart php-fpm && chown apache:apache /coverage/log -R && chmod -R o+r /coverage/log'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
```

6 - Start Selenium Hub
```bash
cd ./test
docker-compose -f docker-compose.yaml up -d
```

7 - Install selenium-side-runner & drivers
```bash
sudo npm install -g selenium-side-runner
```

8 - Clean log and report
```bash
chmod +x ./coverage/tools/cleanReport.sh
mkdir -p ./coverage/log
mkdir -p ./coverage/report
echo '/coverage/tools/cleanReport.sh'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo '/coverage/tools/cleanReport.sh'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
rm -rf ./coverage/log/*
rm -rf ./coverage/report/*
```

9 - Check Selenium and Mediawiki
```bash
cd ./test
chmod +x importFile.sh
./importFile.sh check_mediawiki_1_2.side -o check_mediawiki_1_2_final.side
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=chrome"  ./check_mediawiki_1_2_final.side
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=firefox" ./check_mediawiki_1_2_final.side
```

10 - Init wiki users and a bot
```bash
cd ./test
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=chrome" ./create_users.side
echo 'php /var/www/mediawiki/htdocs/w/maintenance/createBotPassword.php --grants basic,createeditmovepage,editdata,delete,editpage,uploadeditmovefile,uploadfile,highvolume --appid mediawiki1 UserData ff38s9u4feh07vjs2s6t88dh2pv5cfgv' | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
```

11 - Clean log before new tests
```bash
echo '/coverage/tools/cleanReport.sh'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo '/coverage/tools/cleanReport.sh'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
rm -rf ./coverage/log/*
``` 

12 - Execute the test suite of NamespaceData extension
```bash
cd ./test/NamespaceData
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=chrome"  ./suite_tests.side
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=firefox" ./suite_tests.side
cd ../..
echo 'chmod -R o+r /coverage/log'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo 'chmod -R o+r /coverage/log'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
php coverage/tools/createGlobalReportForNamespaceData.php
```

13 - Clean log before new tests
```bash
echo '/coverage/tools/cleanReport.sh'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo '/coverage/tools/cleanReport.sh'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
rm -rf ./coverage/log/*
```

14 - Check Mediawiki API for the PushAll extension
```bash
cd test/api/

sudo printf "\n172.19.0.4      database-test1.localdomain\n172.19.0.5      database-test2.localdomain\n172.19.0.2      serverdev-mediawiki1.localdomain\n172.19.0.3      serverdev-mediawiki2.localdomain\n" >> /etc/hosts

chmod +x *.sh
./test01_login.sh 
./test02_edit.sh 
./test03_upload.sh 
./test04_revisions.sh 
./test05_filesInPage.sh 
./test06_modulesAndTemplatesInPage.sh 
./test07_allpages.sh 
./test08_categorymembers.sh 
./test09_searchPage.sh 
./test10_searchCategory.sh
```

15 - Execute the test suite of PushAll extension
```bash
cd ./test/PushAll
chmod +x clean_mediawiki1.sh
chmod +x clean_mediawiki2.sh
chmod +x make_tests.sh
./make_tests.sh /tmp/test/PushAll
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=chrome"  ./import_final.side
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=chrome"  ./userDataAddRemoteWikis.side
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=chrome"  ./tests_final.side
./clean_mediawiki2.sh
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=firefox" ./tests_final.side
./clean_mediawiki1.sh
./clean_mediawiki2.sh
cd ../..
echo 'chmod -R o+r /coverage/log'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo 'chmod -R o+r /coverage/log'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
php coverage/tools/createGlobalReportForPushAll.php
``` 

16 - Clean log before new tests
```bash
echo '/coverage/tools/cleanReport.sh'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo '/coverage/tools/cleanReport.sh'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
rm -rf ./coverage/log/*
``` 

17 -  Check the code of LinkedWiki extension
```bash
cd ./servers/mediawiki1/htdocs/w/extensions/LinkedWiki/
composer test
yarn test
```

18 -  Execute the test suite of LinkedWiki extension
```bash
cd ./test/LinkedWiki
chmod +x clean_mediawiki1.sh
chmod +x make_tests.sh
./clean_mediawiki1.sh
./make_tests.sh 
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=chrome"  ./tests_final.side
# error with firefox test 32 and 36
#./clean_mediawiki1.sh
#selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=firefox" ./tests_final.side
./clean_mediawiki1.sh
selenium-side-runner  --server http://localhost:4444/wd/hub -c "browserName=chrome"  ./testsJobs_final.side
echo 'curl -iL -H "Accept: text/turtle" http://serverdev-mediawiki1.localdomain/wiki/Data:Test301'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
./clean_mediawiki1.sh
cd ../..
echo 'chmod -R o+r /coverage/log'  | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo 'chmod -R o+r /coverage/log'  | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
php coverage/tools/createGlobalReportForLinkedWiki.php
```

### How to only stop the containers

```bash
docker-compose stop
cd ./test
docker-compose stop
```

### How to restart the containers

```bash
docker-compose start
cd ./test
docker-compose start
```

### How to open the Linux shell for the containers

For http://serverdev-mediawiki1.localdomain/ (admin / dockerpass) :
```bash
docker exec -it instance1.rockylinux-apache-php-mariadb-rdfunit bash
tail /var/log/php-fpm/www-error.log 
tail  /var/log/httpd/error_log -f
```

For http://serverdev-mediawiki2.localdomain/ (admin / dockerpass) :
```bash
docker exec -it instance2.rockylinux-apache-php-mariadb-rdfunit bash
tail /var/log/php-fpm/www-error.log 
tail  /var/log/httpd/error_log -f
```

For http://database-test1.localdomain/ :
```bash
docker exec -it instance1.rockylinux-virtuoso7 bash
```

For http://database-test2.localdomain/ :
```bash
docker exec -it instance2.rockylinux-virtuoso7 bash
```

### Clean all, delete the containers and images

```bash
rm -rf servers/mediawiki1/htdocs 
rm -rf servers/mediawiki2/htdocs 
docker-compose down
cd ./test
docker-compose down
docker image prune -a

rm -f servers/mediawiki1/htdocs/w/LocalSettings.php 
rm -f servers/mediawiki2/htdocs/w/LocalSettings.php 
docker stop instance1.rockylinux-apache-php-mariadb-rdfunit 
docker stop instance2.rockylinux-apache-php-mariadb-rdfunit

docker container rm instance1.rockylinux-apache-php-mariadb-rdfunit
docker container rm instance2.rockylinux-apache-php-mariadb-rdfunit
```

### How to debug the tests

Replace the step 5 by these commands and open the VNC clients with the password "secret"
```bash
cd ./test
docker-compose -f docker-compose-debug.yaml up -d
./start-VNC-Viewer.sh
```

### Rebuild container with new image
```bash
docker-compose pull
docker-compose rm
```

### Errors
#### Host '_gateway' is not allowed to connect to this MariaDB server
```bash
mysql -u root -p
Enter password: dockerpass
mysql>GRANT ALL ON *.* to root@'172.19.0.1' IDENTIFIED BY 'dockerpass';
mysql>FLUSH PRIVILEGES;
mysql>exit
```

### Node & NPM

Install the same version of actions/setup-node@v3 (v16.18.1)
```bash
nvm ls-remote
nvm
nvm install 16.18.1
npm i -g npm@latest
```

### Start the containers of Mediawiki manually
```bash
docker start instance1.rockylinux-apache-php-mariadb-rdfunit 
docker start instance2.rockylinux-apache-php-mariadb-rdfunit
echo 'php /var/www/mediawiki/htdocs/w/maintenance/update.php --quick' | docker exec -i instance1.rockylinux-apache-php-mariadb-rdfunit bash
echo 'php /var/www/mediawiki/htdocs/w/maintenance/update.php --quick' | docker exec -i instance2.rockylinux-apache-php-mariadb-rdfunit bash
```

