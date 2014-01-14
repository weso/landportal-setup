#!/usr/bin/env bash

# --- Change this  default values ---: #
dba_pass=root
# ------------------------------------ #

# Install virtuoso-opensource-6.1
sudo debconf-set-selections <<< 'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password password '$dba_pass''
sudo debconf-set-selections <<< 'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password-again password '$dba_pass''
apt-get install -y virtuoso-opensource


