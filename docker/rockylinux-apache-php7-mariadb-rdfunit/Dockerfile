FROM rockylinux:8
ENV container docker

LABEL maintainer="Karima Rafes <karima.rafes@gmail.com>"

LABEL description="Image docker for rockylinux with apache-php-mariadb-rdfunit"

#update the server
RUN yum -y update; yum clean all;

#HTTPD
RUN yum -y install httpd; yum clean all; systemctl enable httpd.service
EXPOSE 80

#TOOLS
RUN yum install --setopt=tsflags=nodocs -y wget git vim yum-utils  --nogpgcheck

#Add Remi YUM repository
RUN  yum -y install epel-release \
    && yum -y install yum-utils \
    && yum-config-manager --enable powertools \
    && yum -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm

#PHP7.4
RUN  dnf module enable php:remi-7.4 -y \
    && dnf update php\* \
    && yum install php php-opcache php-pecl-xdebug3 php-pdo php-pecl-imagick php-devel php-mbstring  php-mysql php-xml php-gd php-intl -y \
    && rm -rf /var/cache/yum/* \
    && yum clean all
#PHP8
# dnf module reset php
# dnf module enable php:remi-8.0
# dnf update php\*

#MARIADB
RUN wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup \
    && chmod +x mariadb_repo_setup \
    && ./mariadb_repo_setup --skip-maxscale \
    && yum -y install MariaDB-server ; systemctl enable mariadb.service \
    && rm -f mariadb_repo_setup \
    && rm -rf /var/cache/yum/* \
    && yum clean all

EXPOSE	3306

#Tools for Mediawiki (node >v16)
RUN  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && source ~/.bashrc \
    && nvm --version \
    && nvm install v16.12.0 \
    && node --version \
    && npm --version \
    && n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; cp -r $n/{bin,lib,share} /usr/local \
    && yum install gcc-c++ make -y \
    && curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo \
    && yum install yarn composer -y \
    && rm -rf /var/cache/yum/* \
    && yum clean all
    
#Pygments for SyntaxHighlight_GeSHi in Mediawiki
RUN  yum -y install python38 python38-pip \
    && alternatives --set python /usr/bin/python3.8 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3.8 1 \
    && pip install Pygments \
    && rm -rf /var/cache/yum/* \
    && yum clean all
    
#Rapper for Linkedwiki in Mediawiki
RUN  yum -y install raptor2 \
    && rm -rf /var/cache/yum/* \
    && yum clean all

COPY docker/rockylinux-apache-php7-mariadb-rdfunit/apache-maven-3.8.1-bin.tar.gz /tmp/apache-maven-3.8.1-bin.tar.gz
RUN yum install -y java-11-openjdk-devel java-11-openjdk git policycoreutils-python-utils \
    && tar xf /tmp/apache-maven-3.8.1-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-3.8.1 /opt/maven \
    && { \
		echo '#!/bin/bash'; \
		echo 'JAVA_HOME=/etc/alternatives/java_sdk'; \
		echo 'MAVEN_HOME=/opt/maven'; \
		echo 'M2_HOME=/opt/maven'; \
		echo 'M2=/opt/maven/bin'; \
		echo 'PATH=$JAVA_HOME/bin:${M2_HOME}/bin:$PATH'; \
		echo 'export PATH JAVA_HOME M2_HOME MAVEN_HOME'; \
		echo 'export CLASSPATH=.'; \
	} >> /etc/profile.d/maven.sh \
    && chmod +x /etc/profile.d/maven.sh \
    && source /etc/profile.d/maven.sh \
    && rm -rf /var/cache/yum/* \
    && yum clean all
    
COPY docker/rockylinux-apache-php7-mariadb-rdfunit/maven-settings.xml /opt/maven/conf/settings.xml
RUN source /etc/profile.d/maven.sh \
    && mvn -v \
    &&  mkdir -p /usr/share/httpd/.m2/repository \
    && cd / \
    && git clone --depth 1 --branch v0.8.23 https://github.com/AKSW/RDFUnit.git \
    && cd /RDFUnit \
	&& chown apache:apache /usr/share/httpd/.m2 -R \
	&& chown apache:apache /RDFUnit -R  \
    && mvn -pl rdfunit-validate -am clean install -DskipTests=true \
	&& chown apache:apache /usr/share/httpd/.m2 -R \
	&& chown apache:apache /RDFUnit -R
    	
# -----------------------------------------------------------------------------
# Custom XDebug configuration
# -----------------------------------------------------------------------------
#Disable by default XDEBUG3
RUN  { \
		echo 'xdebug.mode = off'; \
		echo ';xdebug.mode = debug'; \
		echo ';xdebug.mode = coverage'; \
		echo 'xdebug.client_host = 172.19.0.1'; \
		echo 'xdebug.client_port = 9000'; \
		echo 'xdebug.start_with_request=yes'; \
		echo ';TODO xdebug.log="/var/log/xdebug.log"' \
		echo 'xdebug.log_level=7'; \
	} >> /etc/php.d/xdebug.ini

# Prepare the configuration to check the coverage

RUN  mkdir -p /coverage/tools \
&& mkdir -p /coverage/log \
&& mkdir -p /coverage/report \
&& cp /etc/php.ini /etc/php_old.ini \
&& chown apache:apache /coverage -R \
&& sed -i 's/auto_prepend_file =/;auto_prepend_file = \/coverage\/tools\/coveragePrepend.php/' /etc/php.ini \
&& sed -i 's/auto_append_file =/;auto_append_file = \/coverage\/tools\/coverageAppend.php/' /etc/php.ini

EXPOSE	9000

CMD ["/usr/sbin/init"]

