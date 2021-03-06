# Run-once script
if [ -f "/vagrant/solr_configured" ]; then
    exit 0
fi
    echo 'Solr already configured!. Delete this to reconfigure Solr stack.' > /vagrant/solr_configured

sed -ri 's/:space:/[:space:]/g' /etc/init.d/jetty

# Setup Jetty. Jetty is the app container under which Solr runs.
sed -i 's|NO_START=1|NO_START=0|g' /etc/default/jetty
sed -i 's|#JETTY_HOST=$(uname -n)|JETTY_HOST=0.0.0.0|g' /etc/default/jetty
sed -i 's|#JETTY_PORT=8080|JETTY_PORT=8983|g' /etc/default/jetty
sed -i 's|#JAVA_HOME=|JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386/|g' /etc/default/jetty
#sudo service jetty start

# Setup Solr multicore configuration file.
sudo ln -s /vagrant/solr/solr.xml /usr/share/solr/

# Create CKAN core data directory.
sudo -u jetty mkdir /var/lib/solr/data/ckan
# Create Drupal core data directory.
sudo -u jetty mkdir /var/lib/solr/data/drupal

# Setup CKAN core configuration files.
sudo mkdir /usr/share/solr/ckan
sudo ln -s /vagrant/solr/ckan/conf/ /usr/share/solr/ckan/conf

# Setup Drupal core configuration files.
sudo mkdir /usr/share/solr/drupal
sudo ln -s /vagrant/solr/drupal/conf/ /usr/share/solr/drupal/conf

# Restart Jetty to load the changes
sudo service jetty restart