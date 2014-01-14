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


















