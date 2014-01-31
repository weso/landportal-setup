#!/usr/bin/env bash

mysql_root_pass=root
app_pass=root
dba_pass=root
landportal_db=landportal
landportal_user_name=lpuser
landportal_user_pass=root


# Create landportal db if not exists
mysql -h localhost -u root -p$mysql_root_pass -e "create database if not exists $landportal_db"

# Grant all privileges to landportal db user
mysql -h localhost -u root -p$mysql_root_pass $landportal_db -e "grant all privileges on $landportal_db.* to $landportal_user_name@localhost identified by '$landportal_user_pass' with grant option"

# Refresh MySQL
mysql -h localhost -u root -p$mysql_root_pass $landportal_db -e "flush privileges"
