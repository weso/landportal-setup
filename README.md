landportal
==========

New version of the International Land Coalition (ILC) Land Portal

### Setup Instructions
1. Install **Virtual Box** <br/> https://www.virtualbox.org/
2. Install **Vagrant** <br/> http://www.vagrantup.com/downloads.html
3. Change the default values in: <br/>

**_/scripts/ckan.sh_** <br/>

```bash
mysql_root_pass=root
app_pass=root
dba_pass=root
```
**_/scripts/ckan.sh_** <br/>

```bash
postgres_user_pass=postgres
ckan_user_name=ckan_default
ckan_user_pass=root
ckan_db_name=ckan_default
ds_user_name=datastore_default
ds_user_pass=root
ds_db_name=datastore_default
```
**_/scripts/drupal.sh_** <br/>

```bash
drupal_db=drupal
drupal_user_name=druser
drupal_user_pass=root
drupal_folder_name=landportal
drupal_site_name=The-Land-Portal
drupal_account_name=admin
drupal_account_pass=admin
```
4.- In command promt run: <br/>

```
vagrant up
```

