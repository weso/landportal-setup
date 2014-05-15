#!/usr/bin/env bash

# --- Change this  default values ---: #
postgres_user_pass=postgres
ckan_user_name=ckan_default
ckan_user_pass=root
ckan_db_name=ckan_default
ds_user_name=datastore_default
ds_user_pass=root
ds_db_name=datastore_default
# ------------------------------------ #

# Run-once script
if [ -f "/vagrant/ckan_configured" ]; then
exit 0
fi
echo 'Ckan already configured!. Delete this to reconfigure CKAN stack.' > /vagrant/ckan_configured

# Fix jetty 6.1 bug
sed -ri 's/:space:/[:space:]/g' /etc/init.d/jetty

# Install CKAN into a Python virtual environment:
mkdir -p /vagrant/ckan/lib
sudo ln -s /vagrant/ckan/lib /usr/lib/ckan
mkdir -p /vagrant/ckan/etc
sudo ln -s /vagrant/ckan/etc /etc/ckan
sudo mkdir -p /usr/lib/ckan/default
sudo chown `whoami` /usr/lib/ckan/default
virtualenv /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate
pip install -e 'git+https://github.com/ckan/ckan.git#egg=ckan'
pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt
deactivate
. /usr/lib/ckan/default/bin/activate

# Setup PostgreSQL database:
sudo -u postgres psql -c"ALTER user postgres WITH PASSWORD '$postgres_user_pass'"
sudo -u postgres dropdb postgres
sudo -u postgres createdb -O postgres postgres --lc-ctype en_US.utf8  --lc-collate en_US.utf8 -E utf-8 -T template0

# Create ckan user:
sudo -u postgres createuser -S -D -R $ckan_user_name
sudo -u postgres psql -c"ALTER user $ckan_user_name WITH PASSWORD '$ckan_user_pass'"

# Creates ckan db:
sudo -u postgres createdb -O $ckan_user_name $ckan_db_name --lc-ctype en_US.utf8  --lc-collate en_US.utf8 -E utf-8 -T template0

# Create a CKAN config file:
sudo mkdir -p /etc/ckan/default
sudo chown -R `whoami` /etc/ckan/
cd /usr/lib/ckan/default/src/ckan
paster make-config ckan /etc/ckan/default/development.ini

# Edit the development.ini file changing the following options:'
sed -i 's/ckan_default:pass/'$ckan_user_name':'$ckan_user_pass'/g' /etc/ckan/default/development.ini

# Setup Solr (Single Solr instance):
#sed -i 's|NO_START=1|NO_START=0|g' /etc/default/jetty
#sed -i 's|#JETTY_HOST=$(uname -n)|JETTY_HOST=127.0.0.1|g' /etc/default/jetty
#sed -i 's|#JETTY_PORT=8080|JETTY_PORT=8983|g' /etc/default/jetty
#sed -i 's|#JAVA_HOME=|JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386/|g' /etc/default/jetty
#sudo service jetty start
#sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
#sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema-2.0.xml /etc/solr/conf/schema.xml
#sudo service jetty restart

# Create database tables:
cd /usr/lib/ckan/default/src/ckan
paster db init -c /etc/ckan/default/development.ini

#7. Set up the DataStore
sed -ri 's/ckan.plugins =/ckan.plugins = datastore/g' /etc/ckan/default/development.ini

# Create datastore user:
sudo -u postgres createuser -S -D -R $ds_user_name
sudo -u postgres psql -c"ALTER user $ds_user_name WITH PASSWORD '$ds_user_pass'"

# Creates datastore db:
sudo -u postgres createdb -O $ckan_user_name $ds_db_name --lc-ctype en_US.utf8  --lc-collate en_US.utf8 -E utf-8 -T template0

# Edit URLs in CKAN config file
sed -ri 's|#ckan.datastore.write_url = postgresql://ckan_default:root@localhost/datastore_default|ckan.datastore.write_url = postgresql://'$ckan_user_name':'$ckan_user_pass'@localhost/'$ds_db_name'|g' /etc/ckan/default/development.ini

sed -ri 's|#ckan.datastore.read_url = postgresql://datastore_default:pass@localhost/datastore_default|ckan.datastore.read_url = postgresql://'$ds_user_name':'$ds_user_pass'@localhost/'$ds_db_name'|g' /etc/ckan/default/development.ini

#Set permissions
cd /usr/lib/ckan/default/src/ckan
paster datastore set-permissions postgres -c /etc/ckan/default/development.ini

# Link to who.ini:
ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

# Deploy CKAN using Apache and modwsgi

#Setup file uploads
sudo mkdir -p /var/lib/ckan/default
sed -i '/[app:main]/aNew ckan.storage_path = /var/lib/ckan/default' /etc/ckan/default/development.ini
sudo chown www-data /var/lib/ckan/default
sudo chmod u+rwx /var/lib/ckan/default
sudo service apache2 reload

# Create a production.ini File
cp /etc/ckan/default/development.ini /etc/ckan/default/production.ini

# Create the WSGI Script File
cp /vagrant/scripts/apache.wsgi /etc/ckan/default/apache.wsgi












