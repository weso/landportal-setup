#!/usr/bin/env bash

# Run-once script
if [ -f "/vagrant/receiver_configured" ]; then
exit 0
fi
echo 'Receiver already configured!. Delete this to reconfigure Receiver stack.' > /vagrant/receiver_configured

# Install Receiver into a Python virtual environment:
mkdir -p /vagrant/virtualenvs/receiver
virtualenv /vagrant/virtualenvs/receiver
. /vagrant/virtualenvs/receiver/bin/activate
cd /vagrant/virtualenvs/receiver
mkdir src
cd src
git clone https://github.com/weso/landportal-receiver.git receiver
# Clone the landportal_model
cd receiver
git clone https://github.com/weso/landportal_model.git model
cd ..
# Install landportal-receiver requirements
pip install -r /vagrant/virtualenvs/receiver/src/receiver/requirements.txt
deactivate
. /vagrant/virtualenvs/receiver/bin/activate
