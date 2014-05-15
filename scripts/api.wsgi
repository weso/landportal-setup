import sys


# Activate landportal-data-access-api virualenv
activate_this = '/vagrant/virtualenvs/api/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))
# Import landportal-data-access-api application
sys.path.insert(0, '/vagrant/landportal-data-access-api/')
from app import app as application
