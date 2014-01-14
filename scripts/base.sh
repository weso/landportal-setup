#!/usr/bin/env bash

# --- Change this  default values ---: #
mysql_root_pass=root
app_pass=root
dba_pass=root
# ------------------------------------ #
if [ -f "/vagrant/delete-this-to-reconfigure" ]; then
exit 0
fi

touch /vagrant/delete-this-to-reconfigure

# Install required packages:
apt-get update
apt-get install -y python-dev postgresql libpq-dev python-pip python-virtualenv git-core solr-jetty openjdk-6-jdk apache2 libapache2-mod-wsgi

# Move Apache to /vagrant directory
sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www

# Install PHP
sudo apt-get install -y php5 libapache2-mod-php5 php5-cli php5-mysql
sudo service apache2 restart

# Install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password '$mysql_root_pass''
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '$mysql_root_pass''
apt-get install -y mysql-server mysql-client libmysqlclient-dev

# Install phpMyAdmin
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password '$app_pass''
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password '$mysql_root_pass''
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password '$mysql_root_pass''
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
apt-get install -y phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/

# Install Drush
apt-get install -y php-pear
sudo pear channel-discover pear.drush.org
sudo pear install drush/drush
wget http://download.pear.php.net/package/Console_Table-1.1.3.tgz
sudo tar zxvf Console_Table-1.1.3.tgz -C /usr/share/php/drush/lib
sudo pear upgrade drush/drush

# Install server requirements for Drupal
apt-get install -y php5-gd
a2enmod rewrite
sudo service apache2 restart

# Install virtuoso-opensource-6.1
sudo debconf-set-selections <<< 'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password password '$dba_pass''
sudo debconf-set-selections <<< 'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password-again password '$dba_pass''
apt-get install -y virtuoso-opensource

# Stablish read permisions
sudo chmod -R 755 /var/www

# Create the Apache Config File
cp /vagrant/scripts/vhost /etc/apache2/sites-available/default_vhost

# Enable the ckan_site
sudo a2ensite default_vhost
sudo a2dissite default

# Reload apache
sudo service apache2 reload
