# openstack usage
Collect the usage tips about OpenStack.

## glance
### HTTPInternalServerError (HTTP 500)
#### issue
```
[root@dog ~]# glance image-create --name "cirros-0.3.4-x86_64" --file cirros-0.3.4-x86_64-disk.img   --disk-format qcow2 --container-format bare --is-public True --progress
[=============================>] 100%
HTTPInternalServerError (HTTP 500)
```
#### solution
The mysql code should set as UTF8. 
Drop and re-create the glance db fix the issue.
```
openstack-db --drop --service glance
openstack-db --init --service glance --password dog
```

### openstack-glance-api dead but pid file exists
#### issue
```
2015-09-17 07:29:05.107 3534 TRACE glance   File "/usr/lib/python2.6/site-packages/stevedore/driver.py", line 50, in _default_on_load_failure
2015-09-17 07:29:05.107 3534 TRACE glance     raise err
2015-09-17 07:29:05.107 3534 TRACE glance ImportError: No module named serialization
```
#### solution
```
[root@dog ~]# yum install python-oslo-serialization

```

### glance-manage db_sync 
#### issue
```
su -s /bin/sh -c "glance-manage db_sync" glance
Traceback (most recent call last):
  File "/usr/bin/glance-manage", line 6, in <module>
    from glance.cmd.manage import main
  File "/usr/lib/python2.6/site-packages/glance/cmd/manage.py", line 47, in <module>
    from glance.db import migration as db_migration
  File "/usr/lib/python2.6/site-packages/glance/db/__init__.py", line 24, in <module>
    from glance.common import crypt
  File "/usr/lib/python2.6/site-packages/glance/common/crypt.py", line 24, in <module>
    from Crypto import Random
ImportError: cannot import name Random
```
#### solution
```
Crypto.__version__ too low, the random include sinec 2.1
[root@dog ~]# yum list python-crypto   
Installed Packages
python-crypto.x86_64                             2.0.1-22.el6                              @anaconda-CentOS-201311272149.x86_64/6.5
Available Packages
python-crypto.x86_64                             2.6.1-1.el6                               suning-juno-deps
yum update python-crypto 
```

### glance image-create fail
#### issue
```
[root@dog ~]# glance image-create --name "cirros-0.3.4-x86_64" --file cirros-0.3.4-x86_64-disk.img   --disk-format qcow2 --container-format bare --is-public True --progress
[=============================>] 100%
<html>
 <head>
  <title>410 Gone</title>
 </head>
 <body>
  <h1>410 Gone</h1>
  Error in store configuration. Adding images to store is disabled.<br /><br />

 </body>
</html> (HTTP N/A)
```
#### solution
```
Comment out the default_store=file under [glance_store], enable it at [default]
Enable filesystem_store_datadir under [glance_store]
```
