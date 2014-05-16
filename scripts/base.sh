#!/usr/bin/env bash

# --- Change this  default values ---: #
mysql_root_pass=root
app_pass=root
dba_pass=root
drupal_db=drupal
drupal_user_name=druser
drupal_user_pass=root
landportal_db=landportal
landportal_user_name=lpuser
landportal_user_pass=root
drupal_dir=portal
drupal_site_name=LandPortal
drupal_user=admin
drupal_pass=admin
# ------------------------------------ #
if [ -f "/vagrant/delete-this-to-reconfigure" ]; then
exit 0
fi

touch /vagrant/delete-this-to-reconfigure

# Install required packages:
apt-get update
apt-get install -y python-dev postgresql libpq-dev python-pip python-virtualenv git-core solr-jetty openjdk-6-jdk apache2 libapache2-mod-wsgi curl

# Move Apache to /vagrant directory
sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www

# Install PHP
sudo apt-get install -y php5 libapache2-mod-php5 php5-cli php5-mysql php5-curl php-apc
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

# Install Drush
apt-get install -y drush

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
sudo ln -s /vagrant/scripts/vhost /etc/apache2/sites-available/default_vhost

# Enable the ckan_site
sudo a2ensite default_vhost
sudo a2dissite default

# Reload apache
sudo service apache2 reload

# Create drupal db and landportal db if not exist
mysql -h localhost -u root -p$mysql_root_pass -e "create database if not exists $drupal_db"
mysql -h localhost -u root -p$mysql_root_pass -e "CREATE DATABASE $landportal_db DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"

# Grant all privileges to drupal db user
mysql -h localhost -u root -p$mysql_root_pass $drupal_db -e "grant all privileges on $drupal_db.* to $drupal_user_name@localhost identified by '$drupal_user_pass' with grant option"

# Refresh MySQL
mysql -h localhost -u root -p$mysql_root_pass $drupal_db -e "flush privileges"

# Install Drupal
    cd /var/www/
    drush dl drupal --drupal-project-rename=$drupal_dir
    cd $drupal_dir
    drush -y site-install standard --db-url=mysql://$drupal_user_name:$drupal_user_pass@localhost/$drupal_db --site-name=$drupal_site_name --account-name=$drupal_user --account-pass=$drupal_pass

    # Assign (sites/default/files) group ownership to the www-data group
    sudo chown -R root:www-data sites/default/files

    # Enable www-data group to write in sites/default/files
    sudo chmod -R 775 sites/default/files

# Allow Drupal to access the Lanbook database
sudo rm -f /vagrant/portal/sites/default/settings.php
sudo ln -s /vagrant/settings.php /vagrant/portal/sites/default

# Install Landportal-Drupal customizations
    cd /var/www
    git clone https://github.com/weso/landportal-drupal.git
    # Link the Landportal-Drupal modules to the Drupal folder
    rm -rf /var/www/$drupal_dir/sites/all
    ln -s /var/www/landportal-drupal/sites/all /var/www/$drupal_dir/sites/all
    cd /var/www/$drupal_dir
    /var/www/landportal-drupal/drupal_config.sh
