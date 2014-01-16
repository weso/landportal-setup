#!/usr/bin/env bash

# --- Change this  default values ---: #
mysql_root_pass=root
drupal_db=drupal
drupal_user_name=druser
drupal_user_pass=root
drupal_dir=/vagrant/public
drupal_git_branch=develop
drupal_git_repo="https://github.com/weso/lp-drupal.git"
# ------------------------------------ #

# Create Drupal db if not exists
mysql -h localhost -u root -p$mysql_root_pass -e "create database if not exists $drupal_db"

# Grant all privileges to drupal db user
mysql -h localhost -u root -p$mysql_root_pass $drupal_db -e "grant all privileges on $drupal_db.* to $drupal_user_name@localhost identified by '$drupal_user_pass' with grant option"

# Refresh MySQL
mysql -h localhost -u root -p$mysql_root_pass $drupal_db -e "flush privileges"

function update_repo {
    if [ -d "$drupal_dir" ] ; then
        (cd $drupal_dir; git checkout $drupal_git_branch)
        (cd $drupal_dir; git pull origin $drupal_git_branch)
    else
        git clone $drupal_git_repo $drupal_dir
        (cd $drupal_dir; git checkout $drupal_git_branch)
    fi
}
update_repo

# Update portal
drush archive-restore /vagrant/public/portal.tar.gz --destination=/vagrant/public/portal --overwrite

cd $drupal_dir/portal
drush archive-dump --destination=/vagrant/public/portal.tar.gz --overwrite

# Assign (sites/default/files) group ownership to the www-data group
 sudo chown -R root:www-data /vagrant/public/portal/sites/default/files

# Enable www-data group to write in sites/default/files
sudo chmod -R 775 /vagrant/public/portal/sites/default/files



