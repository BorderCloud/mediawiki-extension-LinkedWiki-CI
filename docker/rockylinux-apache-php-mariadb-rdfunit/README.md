### Build
```
docker build -f docker/rockylinux-apache-php-mariadb-rdfunit/Dockerfile  -t rockylinux-apache-php-mariadb-rdfunit . 
```

### Build without cache
```
docker build  --rm --no-cache -f docker/rockylinux-apache-php-mariadb-rdfunit/Dockerfile  -t rockylinux-apache-php-mariadb-rdfunit . 
```

### Run
```
docker run --privileged --name  instance.rockylinux-apache-php-mariadb-rdfunit \
        -h rockylinux-apache-php-mariadb-rdfunit \
        -ti \
        -v "/sys/fs/cgroup:/sys/fs/cgroup:ro" \
        -v "$PWD/servers/mediawiki1:/var/www/mediawiki:ro" \
         -v "$PWD/servers/mediawiki1/vhost.conf:/etc/httpd/conf.d/vhost.conf:ro" \
         -v "$PWD/config:/config:ro" \
         -v "$PWD/coverage/tools:/coverage/tools:ro" \
         -v "$PWD/coverage/mediawiki1/log:/coverage/log" \
         -v "$PWD/coverage/mediawiki1/report:/coverage/report" \
        -d rockylinux-apache-php-mariadb-rdfunit
```

### Stop the container
```
docker stop instance.rockylinux-apache-php-mariadb-rdfunit
```

### Start the container
```
docker start instance.rockylinux-apache-php-mariadb-rdfunit
```

### Delete the container
```
docker rm instance.rockylinux-apache-php-mariadb-rdfunit
```

### Open the shell
```
docker exec -it instance.rockylinux-apache-php-mariadb-rdfunit bash
```

### Enable and check the coverage

```
# Enable the mode coverage in XDebug
echo 'sed -i "s/;auto_prepend_file =/auto_prepend_file =/" /etc/php.ini && sed -i "s/;auto_append_file =/auto_append_file =/" /etc/php.ini && sed -i "s/xdebug.mode = off/xdebug.mode = coverage/" /etc/php.d/xdebug.ini && systemctl restart php-fpm'  | docker exec -i instance.rockylinux-apache-php-mariadb-rdfunit bash

# Create a Web page
echo "<?php phpinfo();" > ./servers/mediawiki1/htdocs/index.php

# Execute the page
wget http://172.17.0.2/index.php

# If the coverage works, each interaction with the web site create a JSON.
ls coverage/mediawiki1/log

# This line aggregates all JSON in a file clover.xml for IDE
# This script exits with 0 when the coverage > 95% else it exits with 1
php coverage/tools/createGlobalReport.php

# Find here the report
ls coverage/report
```

### Httpd log

```
tail /var/log/httpd/error_log
```
