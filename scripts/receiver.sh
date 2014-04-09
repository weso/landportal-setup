#!/usr/bin/env bash

# Run-once script
if [ -f "/vagrant/receiver_configured" ]; then
exit 0
fi
echo 'Receiver already configured!. Delete this to reconfigure Receiver stack.' > /vagrant/receiver_configured

# Clone the landportal-receiver and the model source code
cd /vagrant
git clone https://github.com/weso/landportal-receiver.git
cd landportal-receiver
git clone https://github.com/weso/landportal_model.git model
cd ..
# Install Receiver into a Python virtual environment
mkdir -p /vagrant/virtualenvs/receiver
virtualenv /vagrant/virtualenvs/receiver
. /vagrant/virtualenvs/receiver/bin/activate #Activate the virtualenv
cd /vagrant/virtualenvs/receiver
pip install -r /vagrant/landportal-receiver/requirements.txt
deactivate
. /vagrant/virtualenvs/receiver/bin/activate #Reload the virtualenv
# Create and initialize the database schema
cd /vagrant/landportal-receiver
python create_db.py