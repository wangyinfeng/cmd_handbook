OpenStack usage
=============================
Collect the usage tips about OpenStack installing and running.

# nova
## No vnc access from horizon
### solution
```
service  openstack-nova-novncproxy start
service openstack-nova-consoleauth start
```
And maybe the issue about configuration  
https://ask.openstack.org/en/question/520/vnc-console-in-dashboard-fails-to-connect-ot-server-code-1006/

## cannot ping the floating ip from outside or from the VM itself 
Not sure the following matters
```
[root@ovs etc]# sysctl net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.default.rp_filter = 0
[root@ovs etc]# sysctl net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.all.rp_filter = 0
```

### solution
security group issue
```
[root@ovs ~(keystone_admin)]# nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
[root@ovs ~(keystone_admin)]# nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
```

## Cannot find suitable emulator for x86_64
```
[root@dog nova]# tail compute.log 
2015-09-18 06:13:24.759 384 TRACE nova.openstack.common.threadgroup     if ret == -1: raise libvirtError ('virConnectGetVersion() failed', conn=self)
2015-09-18 06:13:24.759 384 TRACE nova.openstack.common.threadgroup libvirtError: internal error: Cannot find suitable emulator for x86_64
2015-09-18 06:13:24.759 384 TRACE nova.openstack.common.threadgroup

[root@dog nova]# qemu-system-x86_64 –help
libvirt does not start because libusb_get_port_numbers symbol is undefined
```

### solution
```
yum install libusbx
```
Should auto install the dependence!

## ERROR (ConnectionError): ('Connection aborted.', error(111, 'Connection refused'))
```
[root@dog ~]# nova service-list
ERROR (ConnectionError): ('Connection aborted.', error(111, 'Connection refused'))

[root@dog nova]# tail -f api.log 
2015-09-23 04:31:14.736 17632 INFO nova.osapi_compute.wsgi.server [-] (17632) wsgi starting up on http://0.0.0.0:8774/
2015-09-23 04:31:15.019 17558 ERROR nova.wsgi [-] Could not bind to 0.0.0.0:8775
2015-09-23 04:31:15.020 17558 CRITICAL nova [-] error: [Errno 98] Address already in use
```

### solution
Check who use the port
```
[root@dog nova]# fuser 8775/tcp
Add –k to kill all the process using that port
[root@dog nova]# fuser -k 8775/tcp
```
Another way is  `tcpkill -9 port PORT_NUMBER` – not verifed

## Migrate instance
```
Error: Failed to launch instance "1": Please try again later [Error: Unexpected error while running command. Command: ssh 10.27.248.3 mkdir -p /var/lib/nova/instances/3185f730-f52e-4e0a-8958-83dd1262936e Exit code: 255 Stdout: u'' Stderr: u'Host key verification failed.\r\n']. 
```
### solution
Solve the passwordless login
```
[root@dog ~]# ssh-copy-id -i .ssh/id_rsa.pub 10.27.248.3
```
http://paste.openstack.org/show/220970/  
https://bugzilla.redhat.com/show_bug.cgi?id=975014#c3  
Set nova’s password, copy nova’s ssh key to make password less login

## Change the location of instance image
Change the configure file `/etc/nova/nova.conf`
```
state_path  = /home/instance
```
The image will store in `/home/instance/instances`, So need to create the `instances` dir also

## “ValueError: I/O operation on closed file”
https://bugs.launchpad.net/horizon/+bug/1451429

## “No valid host was found. There are not enough hosts available.”
Check the log: `Unexpected vif_type=binding_failed`  
 - Maybe the VT not enabled in the bios
 - Work fine for VXLAN network, not work for VLAN network
 - https://bugs.launchpad.net/neutron/+bug/1464554
 - Work fine after restart the network related services
 - OVS related issues. Not exactly know how!
    - neutron-openvswitch-agent not start

## TAP port speed show incorrectly
Check the TAP port speed with ethtool
```
[root@kvmnode002108 ~]# ethtool tapec3e5834-83
Settings for tapec3e5834-83:
        Supported ports: [ ]
        Supported link modes:   Not reported
        Supported pause frame use: No
        Supports auto-negotiation: No
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Speed: 10Mb/s
```
The `speed` is 10Mb/s. That's definitely incorrect.  
Explain from https://bugzilla.redhat.com/show_bug.cgi?id=1168478
> vNIC reported "speed" is an utterly fake number, that has nothing to do with vNIC QoS capping.


# keystone
## Invalid OpenStack Identity credentials
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

# MQ
## AMQP: [Errno 113] EHOSTUNREACH
```
2015-09-23 19:47:47.478 28758 INFO oslo.messaging._drivers.impl_rabbit [req-5bc81fae-e595-4fb3-b26d-1acd03af6275 ] Connecting to AMQP server on 10.27.248.252:5672
2015-09-23 19:47:47.491 28758 ERROR oslo.messaging._drivers.impl_rabbit [req-5bc81fae-e595-4fb3-b26d-1acd03af6275 ] AMQP server on 10.27.248.252:5672 is unreachable: [Errno 113] EHOSTUNREACH. Trying again in 23 seconds.
```
### solution
Firewall issue! http://www.bubuko.com/infodetail-917191.html
```
[root@dog ~]# iptables -I INPUT -p tcp --dport 5672 -j ACCEPT
[root@dog ~]# service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
[root@dog ~]# service iptables restart
```
Happened again! The MQ server already configured the iptables… Restart the iptables server solve the issue!


# glance
## HTTPInternalServerError (HTTP 500)
```
[root@dog ~]# glance image-create --name "cirros-0.3.4-x86_64" --file cirros-0.3.4-x86_64-disk.img   --disk-format qcow2 --container-format bare --is-public True --progress
[=============================>] 100%
HTTPInternalServerError (HTTP 500)
```
### solution
The mysql code should set as UTF8. 
Drop and re-create the glance db fix the issue.
```
openstack-db --drop --service glance
openstack-db --init --service glance --password dog
```

## openstack-glance-api dead but pid file exists
```
2015-09-17 07:29:05.107 3534 TRACE glance   File "/usr/lib/python2.6/site-packages/stevedore/driver.py", line 50, in _default_on_load_failure
2015-09-17 07:29:05.107 3534 TRACE glance     raise err
2015-09-17 07:29:05.107 3534 TRACE glance ImportError: No module named serialization
```
### solution
```
[root@dog ~]# yum install python-oslo-serialization

```

## glance-manage db_sync 
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
### solution
```
Crypto.__version__ too low, the random include sinec 2.1
[root@dog ~]# yum list python-crypto   
Installed Packages
python-crypto.x86_64                             2.0.1-22.el6                              @anaconda-CentOS-201311272149.x86_64/6.5
Available Packages
python-crypto.x86_64                             2.6.1-1.el6                               suning-juno-deps
yum update python-crypto 
```

## glance image-create fail
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
### solution
```
Comment out the default_store=file under [glance_store], enable it at [default]
Enable filesystem_store_datadir under [glance_store]
```

# Horizon
### An error occurred authenticating. Please try again later
When login the dashboard, error happened.
https://ask.openstack.org/en/question/4567/cant-login-to-dashboard-an-error-occurred-authenticating-please-try-again-later/

Disable the selinux or
```
setsebool -P httpd_can_network_connect 1
```

## Permission denied: '/tmp/.secret_key_store
```
[Wed Sep 23 04:48:36 2015] [error] [client 10.24.74.187]   File "/usr/lib/python2.6/site-packages/horizon/utils/secret_key.py", line 56, in generate_or_read_from_file
[Wed Sep 23 04:48:36 2015] [error] [client 10.24.74.187]     with open(key_file, 'w') as f:
[Wed Sep 23 04:48:36 2015] [error] [client 10.24.74.187] IOError: [Errno 13] Permission denied: '/tmp/.secret_key_store‘
```
Edit the file: /etc/openstack-dashboard/local_settings. Set the SECRET_KEY with string instead reading from file.


## cinder_volum doesnot exist
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

## InternalServerError: An unexpected error prevented the server from fulfilling your request
Check the keystone.log
```
Too many connections
```
### solution
Increase the max_connections in /etc/my.conf
```
max_connections = 1000
```

## Dashboard only accessable on localhost
```
[root@dog ~]# service httpd restart
Stopping httpd:                                            [  OK  ]
Starting httpd: httpd: apr_sockaddr_info_get() failed for dog.cat
httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName
                                                           [  OK  ]
```
### solution
iptables issue, copy the /etc/syconfig/iptables from other server and restart iptables service

## Timed out waiting for a reply to message ID
```
2015-09-23 19:55:56.170 28758 ERROR nova.openstack.common.periodic_task [-] Error during ComputeManager._heal_instance_info_cache: Timed out waiting for a reply to message ID 0056214818ef4bcb9a18fc1788ab7241
```
Also iptables issue
```
Service iptables stop 
```
at compute node


## oslo ERROR
```
2015-09-24 07:35:41.713 2060 ERROR oslo.messaging._drivers.common [-] Returning exception _oslo_messaging_localcontext_569859d7f2df40daa10c3a3786287788 to caller
2015-09-24 07:35:41.713 2060 ERROR oslo.messaging._drivers.common [-] ['Traceback (most recent call last):\n', '  File "/usr/lib/python2.6/site-packages/oslo/messaging/rpc/dispatcher.py", line 134, in _dispatch_and_reply\n    incoming.message))\n', '  File "/usr/lib/python2.6/site-packages/oslo/messaging/rpc/dispatcher.py", line 179, in _dispatch\n    localcontext.clear_local_context()\n', '  File "/usr/lib/python2.6/site-packages/oslo/messaging/localcontext.py", line 55, in clear_local_context\n    delattr(_STORE, _KEY)\n', 'AttributeError: _oslo_messaging_localcontext_569859d7f2df40daa10c3a3786287788\n']
```
http://osdir.com/ml/openstack-dev/2015-05/msg00435.html

must do the monkey patching before anything else even loading another module that eventlet. – I change the monkey_path(os=False, thread=False) for debug purpose.

## Horizon cannot access the instance’s console
http://docs.openstack.org/havana/config-reference/content/vnc-configuration-options.html

Configure the vnc

# neutron
## neutron-server cannot start
```
[root@dog ~]# service neutron-server start 
[root@dog ~]# service neutron-server status
neutron is stopped
```
### solution
check the neutron-server process, make sure the configure `plugin.ini` location is correct.
```
neutron   2830  1.4  0.0 396372 60980 ?        S    02:55   0:01 /usr/bin/python /usr/bin/neutron-server --config-file /usr/share/neutron/neutron-dist.conf --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini --log-file /var/log/neutron/server.log
[root@dog neutron]# ln -s /etc/neutron/plugins/ml2/ml2_conf.ini plugin.ini
```

## Unable to establish connection to http://10.27.248.252:9696/v2.0/agents.json
```
[root@dog ~]# neutron agent-list
Unable to establish connection to http://10.27.248.252:9696/v2.0/agents.json
```
### solution
Make sure keystone is running



## Invalid input for operation: physical_network physnet2 unknown for VLAN provider network
### solution
Do the configuration in the file plugin.ini
```
network_vlan_ranges =physnet2,default:10:4000
```
Then
```
[root@dog neutron]# service neutron-server restart
```

## Not support multi external network by default
When Create router to interconnect two networks, error message raise 
```
“2015-08-26 14:24:36.100 28783 ERROR oslo_messaging._drivers.common [req-af94a551-fbcd-4077-aa86-ca26aa2be3ad ] ['Traceback (most recent call last):\n', '  …in get_external_network_id\n    raise n_exc.TooManyExternalNetworks()\n', 'TooManyExternalNetworks: More than one external network exists\n']”
```
By default, L3 agent is not support multi external network. I create another network with flag external, so I have 2 networks with label “external”. 
### solution
if wan to use more than one external network, follow the guide:
http://blog.oddbit.com/2014/05/28/multiple-external-networks-wit/

## Attach VM to external network directly?
No that is not possible. External networks are only for uplinking routers that do NAT between private IPs and floating IPs (or the gateway IP).
https://ask.openstack.org/en/question/3086/directly-connect-vm-to-external-network/
### solution
Using flat network:
https://trickycloud.wordpress.com/2013/11/12/setting-up-a-flat-network-with-neutron/


## Namesapce not delete after the network/router is deleted
```
[root@ovs images]# ip netns
qrouter-72cb8203-67e4-4d9b-9bbf-614af6f29af4
qrouter-21013404-bfba-4189-9f31-ca18e0765325
qrouter-1adf4f50-8f25-4685-9af4-fda0f2309a31
qdhcp-12756f46-a707-4f1b-8b5f-7fd6a71eb0f6
qdhcp-71b07a6b-8eee-4e44-9818-017fe4159248
qdhcp-48e03f60-2f3b-4b41-b3f8-85adf7a085f3
qdhcp-0d39466a-6349-4e09-b90f-d1660285f76b
qrouter-953b5272-c8b1-4c7e-84d0-99970ac115fa
qdhcp-f2a951b2-b0e2-4a1c-ab58-aa5c7a57d425
qdhcp-8cb97be7-eb0c-4b5a-b65b-472a1e61a564
```
### solution
configure the folowing parameter in the configure file:
```
router_delete_namespaces
dhcp_delete_namespaces
```
https://bugs.launchpad.net/neutron/+bug/1052535

## Not able to allocate the floating IP.
```
Error: The server has either erred or is incapable of performing the requested operation. (HTTP 500) (Request-ID: req-cb1e2a3f-160a-4786-80b8-e49a1ca373c1) 
```
### solution
Configure the default_floating_pool=public <- the external network

https://www.mirantis.com/blog/configuring-floating-ip-addresses-networking-openstack-public-private-clouds/

