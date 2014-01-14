#!/usr/bin/env bash

# --- Change this  default values ---: #
mysql_root_pass=root
app_pass=root
drupal_db=drupal
drupal_user_name=druser
drupal_user_pass=root
drupal_folder_name=landportal
drupal_site_name=The-Land-Portal
drupal_account_name=admin
drupal_account_pass=admin
# ------------------------------------ #

# Run-once script
if [ -f "/vagrant/drupal_configured" ]; then
exit 0
fi
echo 'Drupal already configured!. Delete this to reconfigure Drupal stack.' > /vagrant/drupal_configured

# Update system
apt-get update

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

# Deploying a new Drupal site with Drush
# Create Drupal db
mysql -h localhost -u root -p$mysql_root_pass -e "create database $drupal_db"

# Create drupal db user
mysql -h localhost -u root -p$mysql_root_pass $drupal_db -e "create user $drupal_user_name@localhost"

# Set password to drupal db user
mysql -h localhost -u root -p$mysql_root_pass $drupal_db -e "set password for $drupal_user_name@localhost= password ('$drupal_user_pass')"

# Grant all privileges to drupal db user
mysql -h localhost -u root -p$mysql_root_pass $drupal_db -e "grant all privileges on $drupal_db.* to $drupal_user_name@localhost identified by '$drupal_user_pass' with grant option"

# Refresh MySQL
mysql -h localhost -u root -p$mysql_root_pass $drupal_db -e "flush privileges"

# Navigate to www folder
cd /var/www

# Download Drupal
drush dl drupal --drupal-project-rename=$drupal_folder_name

# Install Drupal
cd /var/www/$drupal_folder_name
drush -y site-install standard --db-url=mysql://$drupal_user_name:$drupal_user_pass@localhost/$drupal_db --site-name=$drupal_site_name --account-name=$drupal_account_name --account-pass=$drupal_account_pass

# Assign (sites/default/files) group ownership to the www-data group
sudo chown -R root:www-data sites/default/files

# Enable www-data group to write in sites/default/files
sudo chmod -R 775 sites/default/files


















