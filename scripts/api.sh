#!/usr/bin/env bash

# Run-once script
if [ -f "/vagrant/api_configured" ]; then
exit 0
fi
echo 'API already configured!. Delete this to reconfigure API stack.' > /vagrant/api_configured

# Clone the landportal-receiver and the model source code
cd /vagrant
git clone https://github.com/weso/landportal-data-access-api.git
# Install API into a Python virtual environment
mkdir -p /vagrant/virtualenvs/api
virtualenv /vagrant/virtualenvs/api
. /vagrant/virtualenvs/api/bin/activate #Activate the virtualenv
cd /vagrant/virtualenvs/api
pip install -r /vagrant/landportal-data-access-api/requirements.txt
deactivate
. /vagrant/virtualenvs/api/bin/activate #Reload the virtualenv
