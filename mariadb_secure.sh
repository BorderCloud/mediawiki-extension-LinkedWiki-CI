#!/bin/bash

# echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'dockerpass'; flush privileges;" | mariadb -u root@localhost

systemctl restart mariadb.service

RESULT=$(expect -c "

set timeout 10
spawn mariadb-secure-installation

expect \"Enter current password for root (enter for none):\"
send \"\r\"

expect \"Switch to unix_socket authentication\"
send \"n\r\"

expect \"Change the root password?\"
send \"y\r\"

expect \"New password:\"
send \"dockerpass\r\"

expect \"Re-enter new password:\"
send \"dockerpass\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")

echo "$RESULT"
