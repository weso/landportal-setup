landportal
==========

New version of the International Land Coalition (ILC) Land Portal

### Setup Instructions
1. Install **Virtual Box** <br/> https://www.virtualbox.org/
2. Install **Vagrant** <br/> http://www.vagrantup.com/downloads.html
3. Change the default values in: <br/>

**_/scripts/base.sh_** <br/>

```bash
mysql_root_pass=root
app_pass=root
dba_pass=root
```
4.- In command prompt run (in Windows use a command prompt with administrator privileges): <br/>

```
vagrant up
```

