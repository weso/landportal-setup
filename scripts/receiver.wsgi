import sys


# Activate landportal-receiver virualenv
activate_this = '/vagrant/virtualenvs/receiver/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))
# Import landportal-receiver application
sys.path.insert(0, '/vagrant/virtualenvs/receiver/src/receiver/')
from app import app as application
