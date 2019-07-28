# Install MySQL 5.6.45
## Install library dependency
sudo apt-get install libaio1
## Download generic binaries from Oracle.
wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.45-linux-glibc2.12-x86_64.tar.gz
tar -xf mysql-5.6.45-linux-glibc2.12-x86_64.tar.gz

# Follow the instructions of: https://dev.mysql.com/doc/refman/5.6/en/binary-installation.html
sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql
rm mysql-5.6.45-linux-glibc2.12-x86_64.tar.gz
sudo ln -s `pwd`/mysql-5.6.45-linux-glibc2.12-x86_64 /usr/local/mysql
export PATH=$PATH:/usr/local/mysql/bin
sudo /usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir /usr/local/mysql --datadir=/usr/local/mysql/data
sudo /usr/local/mysql/bin/mysqld_safe &
/usr/local/mysql/bin/mysql_secure_installation
