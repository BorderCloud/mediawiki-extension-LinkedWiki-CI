FROM rockylinux:8
ENV container docker

LABEL maintainer="Karima Rafes <karima.rafes@gmail.com>"

LABEL description="Image docker for rockylinux with Virtuoso7"

#update the server
RUN yum -y update; yum clean all;


RUN  yum -y install epel-release \
    && yum -y install yum-utils \
    && yum-config-manager --enable powertools  \
    && yum install langpacks-en langpacks-fr glibc-all-langpacks -y \
    && yum -y groupinstall "Development Tools" \
	&& yum install -y gcc  autoconf automake libtool \
               flex bison gperf gawk m4 make \
               openssl openssl-devel readline-devel wget \
               libxml2-devel libuuid-devel uuid-devel \
               ImageMagick ImageMagick-devel openldap-devel \
                net-tools git \
               make  mailx \
               gperf \
	&& rm -rf /var/cache/yum/* \
	&& yum clean all

#build virtuoso
RUN  git clone --depth 1 -b stable/7 https://github.com/openlink/virtuoso-opensource.git \
    && cd virtuoso-opensource \
    && export CFLAGS="-O2 -m64" \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local/virtuoso \
            --enable-ods-vad \
            --with-readline \
            && make \
            && make install


RUN  ln -s /usr/local/virtuoso/bin/virtuoso-t /usr/bin/virtuoso-t  2>&1 || true \
&& ln -s /usr/local/virtuoso/bin/isql /usr/bin/isql  2>&1 || true \
&& mkdir /data \
&& cp /usr/local/virtuoso/var/lib/virtuoso/db/virtuoso.ini /data/virtuoso.ini \
&& sed -i 's/\/usr\/local\/virtuoso\/var\/lib\/virtuoso\/db/\/data/' /data/virtuoso.ini

RUN { \
		echo '#!/bin/sh'; \
		echo '# description: Script to start the server Virtuoso'; \
		echo ''; \
		echo 'DBAPASSWORD="dba"'; \
		echo 'CONFIGFILE="/data/virtuoso.ini"'; \
		echo '#INITBD="/data/init.sql"'; \
		echo ''; \
		echo 'virtuoso-t -c $CONFIGFILE +wait'; \
		echo '#isql 1111 dba $DBAPASSWORD $INITBD'; \
	} >> /data/start.sh

RUN { \
		echo '#!/bin/sh'; \
		echo '# description: Script to stop the server Virtuoso'; \
		echo ' '; \
		echo 'DBAPASSWORD="dba"'; \
		echo ' '; \
		echo 'isql 1111 dba $DBAPASSWORD -K'; \
		echo 'sleep 5'; \
		} >> /data/stop.sh

RUN { \
		echo ''; \
		echo '[Unit]'; \
		echo 'Description=Virtuoso Open-Source server daemon'; \
		echo 'After=network.target'; \
		echo ''; \
		echo '[Service]'; \
		echo 'Type=simple'; \
		echo 'Restart=always'; \
		echo 'RestartSec=5'; \
		echo 'ExecStart=/usr/bin/virtuoso-t -f -c /data/virtuoso.ini +wait'; \
		echo 'ExecReload=/data/stop.sh'; \
		echo 'ExecStop=/data/stop.sh'; \
		echo 'PrivateTmp=true'; \
		echo ''; \
		echo '[Install]'; \
		echo 'WantedBy=multi-user.target'; \
	} >> /etc/systemd/system/virtuoso.service
	
	

RUN chmod +x /data/start.sh \
	&& chmod +x /data/stop.sh \
	&& systemctl enable virtuoso
	
# Enable CORS
COPY docker/rockylinux-virtuoso7/enable_CORS_all_domains.sql /tmp/enable_CORS_all_domains.sql
RUN virtuoso-t -c /data/virtuoso.ini +wait \
 	&& isql 1111 dba dba /tmp/enable_CORS_all_domains.sql \
 	&& isql 1111 dba dba -K \
 	&& sleep 5

# --build-arg initfile=grantAll.sql
# --build-arg initfile=grantPrivate.sql
# --build-arg initfile=grantPublic.sql
# ARG initfile=grantAll.sql
# COPY $initfile /data/virtuoso_init.sql
# RUN virtuoso-t -c /data/virtuoso.ini +wait \
# 	&& isql 1111 dba dba /data/virtuoso_init.sql \
# 	&& isql 1111 dba dba -K \
# 	&& sleep 5

EXPOSE 8890

RUN yum install -y yum-utils automake autoconf libtool ncurses-devel libxslt groff pcre-devel pkgconfig \
                    python3 python3-pip \
    && pip3 install docutils \
    && cd /tmp \
    && wget https://packagecloud.io/install/repositories/varnishcache/varnish60lts/script.rpm.sh \
    && chmod +x ./script.rpm.sh \
    && ./script.rpm.sh \
    && yum install -y varnish varnish-devel \
    && cd /tmp \
	&& git clone --depth 1 --branch 6.0-lts https://github.com/varnish/varnish-modules.git \
    && cd varnish-modules \
    && ./bootstrap  \
    && ./configure \
    && make \
    && make install 
    
COPY docker/rockylinux-virtuoso7/varnish.service /etc/systemd/system
COPY docker/rockylinux-virtuoso7/default.vcl /etc/varnish/default.vcl

RUN systemctl enable varnish

RUN virtuoso-t -h || (exit 0)

EXPOSE 80
            
CMD ["/usr/sbin/init"]
