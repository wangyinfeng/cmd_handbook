# openstack usage
Collect the usage tips about OpenStack.

## keystone
### Invalid OpenStack Identity credentials
```
[root@dog ~]# service keystone status
keystone: unrecognized service
```

-> service openstack-keystone start
```
[root@dog ~]# keystone tenant-create --name admin --description "Admin Tenant"
Invalid OpenStack Identity credentials.
The token use the one configured in keystone.conf
export OS_SERVICE_TOKEN=6c07f4b6d16c525d3493
```
-> cat /etc/keystone/keystone.conf | grep admin_token

## MQ
### AMQP: [Errno 113] EHOSTUNREACH
```
2015-09-23 19:47:47.478 28758 INFO oslo.messaging._drivers.impl_rabbit [req-5bc81fae-e595-4fb3-b26d-1acd03af6275 ] Connecting to AMQP server on 10.27.248.252:5672
2015-09-23 19:47:47.491 28758 ERROR oslo.messaging._drivers.impl_rabbit [req-5bc81fae-e595-4fb3-b26d-1acd03af6275 ] AMQP server on 10.27.248.252:5672 is unreachable: [Errno 113] EHOSTUNREACH. Trying again in 23 seconds.
```
#### solution
Firewall issue! http://www.bubuko.com/infodetail-917191.html
```
[root@dog ~]# iptables -I INPUT -p tcp --dport 5672 -j ACCEPT
[root@dog ~]# service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
[root@dog ~]# service iptables restart
```
Happened again! The MQ server already configured the iptables… Restart the iptables server solve the issue!


## glance
### HTTPInternalServerError (HTTP 500)
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

## Horizon
#### An error occurred authenticating. Please try again later
When login the dashboard, error happened.
https://ask.openstack.org/en/question/4567/cant-login-to-dashboard-an-error-occurred-authenticating-please-try-again-later/

Disable the selinux or
```
setsebool -P httpd_can_network_connect 1
```

### Permission denied: '/tmp/.secret_key_store
```
[Wed Sep 23 04:48:36 2015] [error] [client 10.24.74.187]   File "/usr/lib/python2.6/site-packages/horizon/utils/secret_key.py", line 56, in generate_or_read_from_file
[Wed Sep 23 04:48:36 2015] [error] [client 10.24.74.187]     with open(key_file, 'w') as f:
[Wed Sep 23 04:48:36 2015] [error] [client 10.24.74.187] IOError: [Errno 13] Permission denied: '/tmp/.secret_key_store‘
```
Edit the file: /etc/openstack-dashboard/local_settings. Set the SECRET_KEY with string instead reading from file.


### cinder_volum doesnot exist
Open dashboard to create instance, some error show about cinder_volum doesnot exist, check the horizon error.log
```
[Wed Sep 23 12:19:59 2015] [error]     raise exceptions.ConnectionError(msg)
[Wed Sep 23 12:19:59 2015] [error] ConnectionError: Unable to establish connection: ('Connection aborted.', error(111, 'Connection refused'))
```
If not use cinder, delete it from keystone. 
```
Keystone service-delete xxxxx
Keystone endpoint-delete xxxx
Service openstack-keystone restart
```
```
[root@dog nova]# tail  compute.log    
2015-09-20 21:31:55.282 24249 AUDIT nova.compute.resource_tracker [-] Auditing locally available compute resources
2015-09-20 21:31:55.368 24249 ERROR nova.virt.libvirt.driver [-] This is no cinder_volume_group vg         No harm by now
```

### InternalServerError: An unexpected error prevented the server from fulfilling your request
Check the keystone.log
```
Too many connections
```
#### solution
Increase the max_connections in /etc/my.conf
```
max_connections = 1000
```

### Dashboard only accessable on localhost
```
[root@dog ~]# service httpd restart
Stopping httpd:                                            [  OK  ]
Starting httpd: httpd: apr_sockaddr_info_get() failed for dog.cat
httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName
                                                           [  OK  ]
```
#### solution
iptables issue, copy the /etc/syconfig/iptables from other server and restart iptables service

### Timed out waiting for a reply to message ID
```
2015-09-23 19:55:56.170 28758 ERROR nova.openstack.common.periodic_task [-] Error during ComputeManager._heal_instance_info_cache: Timed out waiting for a reply to message ID 0056214818ef4bcb9a18fc1788ab7241
```
Also iptables issue
```
Service iptables stop 
```
at compute node


### oslo ERROR
```
2015-09-24 07:35:41.713 2060 ERROR oslo.messaging._drivers.common [-] Returning exception _oslo_messaging_localcontext_569859d7f2df40daa10c3a3786287788 to caller
2015-09-24 07:35:41.713 2060 ERROR oslo.messaging._drivers.common [-] ['Traceback (most recent call last):\n', '  File "/usr/lib/python2.6/site-packages/oslo/messaging/rpc/dispatcher.py", line 134, in _dispatch_and_reply\n    incoming.message))\n', '  File "/usr/lib/python2.6/site-packages/oslo/messaging/rpc/dispatcher.py", line 179, in _dispatch\n    localcontext.clear_local_context()\n', '  File "/usr/lib/python2.6/site-packages/oslo/messaging/localcontext.py", line 55, in clear_local_context\n    delattr(_STORE, _KEY)\n', 'AttributeError: _oslo_messaging_localcontext_569859d7f2df40daa10c3a3786287788\n']
```
http://osdir.com/ml/openstack-dev/2015-05/msg00435.html

must do the monkey patching before anything else even loading another module that eventlet. – I change the monkey_path(os=False, thread=False) for debug purpose.

### Horizon cannot access the instance’s console
http://docs.openstack.org/havana/config-reference/content/vnc-configuration-options.html

Configure the vnc



