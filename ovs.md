OVS components and commands
=========================
# build and compile
## Compile form source code
Kerenel version support from 2.6.32 - 3.14(read the FAQ)
```
./boot.sh
./configure --prefix=/usr --with-linux=/lib/modules/`uname -r`/build
make
make modules_install
make install
modprobe openvswitch
```
(Has issues, configure hang when write to db; and port cannot be seen with ip link)  
(to verify http://blog.onos.top/linux/2015/01/06/install-openvswitch-on-ubuntu14.04lts/ )

## Build deb package 
(http://www.docoreos.com/?p=79 )  
检查下是否依赖包已经安装完毕`dpkg-checkbuilddeps`  
构建安装包
```
DEB_BUILD_OPTIONS='parallel=8 nocheck' 
fakeroot debian/rules binary
dpkg -i openvswitch-common_2.3.2-1_amd64.deb  openvswitch-switch_2.3.2-1_amd64.deb
```

## Build rpm package
(https://pario.no/2015/05/26/installing-open-vswitch-on-centos-7/）
```
yum groupinstall "Development Tools"
mkdir -p ~/rpmbuild/SOURCES
cd ~/rpmbuild/SOURCES
wget http://openvswitch.org/releases/openvswitch-2.3.1.tar.gz
tar xfz openvswitch-2.3.1.tar.gz
sed 's/openvswitch-kmod, //g' openvswitch-2.3.1/rhel/openvswitch.spec > openvswitch-2.3.1/rhel/openvswitch_no_kmod.spec
rpmbuild -bb --nocheck ~/openvswitch-2.3.1/rhel/openvswitch_no_kmod.spec
yum localinstall /home/ovswitch/rpmbuild/RPMS/x86_64/openvswitch-2.3.1-1.x86_64.rpm
```

# OVS components 
## ovs-vswitchd
Core component in the system
- Communicates with outside world using OpenFlow
- Communicates with ovsdb-server using management protocol
- Communicates with kernel module over netlink
- Communicates with the system through netdev abstract interface

Supports multiple independent datapaths (bridges)  
Packet classifier supports efficient flow lookup with wildcards and “explodes” these (possibly) wildcard rules for fast processing by the datapath  
Implements mirroring, bonding, and VLANs through modifications of the same flow table exposed through OpenFlow  
Check datapath flow counters to handle flow expiration and stats request  

## openvswitch_mod.ko
Kernel module that handles switching and tunneling
- Exact-match cache of flows
- Designed to be fast and simple
- Packet comes in, if found, associated actions executed and counters updated. Otherwise, sent to userspace
- Does no flow expiration
- Knows nothing of OpenFlow
- Implements tunnels
 
### Check kernel module version
```
[root@osnode002001 ~]# modinfo openvswitch
filename:       /lib/modules/2.6.32-431.el6.x86_64/weak-updates/openvswitch/openvswitch.ko
version:        2.3.1
license:        GPL
description:    Open vSwitch switching datapath
srcversion:     4D7CD38A83A9A4A782F73A1
depends:        libcrc32c
vermagic:       2.6.32-504.3.3.el6.x86_64 SMP mod_unload modversions 
parm:           vlan_tso:Enable TSO for VLAN packets (int)
```

## commands
- ovs-appctl发送命令消息，运行相关daemon
- ovs-vswitchd 守护程序，实现交换功能，和Linux内核模块一起，实现基于流的交换flow-based switching。
- ovsdb-server轻量级的数据库服务，保存OVS的配置信息
- ovsdb-tool
- ovsdb-client
- ovs-l3ping
- ovs-vlan-test
- ovs-benchmark
- ovs-vsctl获取或者更改ovs-vswitchd的配置信息，此工具操作的时候会更新ovsdb-server中的数据库
- ovs-bugtool
- ovs-dpctl 配置交换机内核模块
- ovs-dpctl-top
- ovs-parse-backtrace
- ovs-test
- ovs-pcap
- ovs-vlan-bug-workaround 
- ovs-appctl发送命令消息，运行相关daemon
- ovs-vswitchd 守护程序，实现交换功能，和Linux内核模块一起，实现基于流的交换flow-based switching。
- ovsdb-server轻量级的数据库服务，保存OVS的配置信息
- ovsdb-tool
- ovsdb-client
- ovs-l3ping
- ovs-vlan-test
- ovs-benchmark
- ovs-vsctl获取或者更改ovs-vswitchd的配置信息，此工具操作的时候会更新ovsdb-server中的数据库
- ovs-bugtool
- ovs-dpctl 配置交换机内核模块
- ovs-dpctl-top
- ovs-parse-backtrace
- ovs-test
- ovs-pcap
- ovs-vlan-bug-workaround 



# system
## set the number of handler/revalidator threads
```
ovs-vsctl --no-wait set Open_vSwitch . other_config:n-handler-threads=12
```
Specifies the number of threads for software datapaths to use for handling new flows. The default the number of online CPU cores minus the number of revalidators.
This configuration is per datapath.  If you have more than one software datapath (e.g. some system bridges and some Netdev bridges), then the total number of threads is n-handler-threads times the number of software datapaths.

```
ovs-vsctl --no-wait set Open_vSwitch . other_config:n-revalidator-threads=8
```
Specifies the number of threads for software datapaths to use for revalidating flows in the datapath.  Typically, there is a direct  correlation between the number of revalidator threads, and the number of flows allowed in the datapath.  The default is the number of cpu cores divided by four plus one.  If n-handler-threads is set, the default  changes to the number of cpu cores minus the number of handler threads.

This configuration is per datapath.  If you have more than one software datapath (e.g. some system bridges and some netdev bridges), then the total number of threads is n-handler-threads times the number of software datapaths.



# port
##dump port statistics
```
[root@kvmnode002108 ~]# ovs-ofctl dump-ports br-bond1  
OFPST_PORT reply (xid=0x2): 3 ports
  port  8: rx pkts=173661128, bytes=26733568116, drop=0, errs=0, frame=0, over=0, crc=0
           tx pkts=2011912554, bytes=448454625257, drop=0, errs=0, coll=0
  port LOCAL: rx pkts=6, bytes=468, drop=0, errs=0, frame=0, over=0, crc=0
           tx pkts=2030080686, bytes=334610413022, drop=9877323096, errs=0, coll=0
  port  1: rx pkts=20991153020, bytes=3026825890957, drop=0, errs=0, frame=0, over=0, crc=0
           tx pkts=1320548559, bytes=468321506901, drop=0, errs=0, coll=0
```
or
```
[root@dog neutron]# ovs-vsctl get interface eth1 statistics
{collisions=0, rx_bytes=14449413, rx_crc_err=0, rx_dropped=0, rx_errors=0, rx_frame_err=0, rx_over_err=0, rx_packets=57270, tx_bytes=601444, tx_dropped=0, tx_errors=0, tx_packets=9320}

```

## check/change tx queue
Check tx queue length
```
[root@fish ~]# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
    link/ether 6c:92:bf:07:14:99 brd ff:ff:ff:ff:ff:ff
```
or
```
[root@fish ~]# cat /sys/class/net/qvbcbf85285-5d/tx_queue_len                       
1000
```

change tx queue length
```
[root@fish ~]# echo 1000 > /sys/class/net/qvbcbf85285-5d/tx_queue_len 
[root@fish ~]# ifconfig qvbcbf85285-5d                                
qvbcbf85285-5d Link encap:Ethernet  HWaddr D2:87:EA:A7:7E:7F  
          inet6 addr: fe80::d087:eaff:fea7:7e7f/64 Scope:Link
          UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1500  Metric:1
          RX packets:6 errors:0 dropped:0 overruns:0 frame:0
          TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:468 (468.0 b)  TX bytes:678 (678.0 b)
```
or
```
[root@fish ~]# ip link set txqueuelen 1000 dev qvbcbf85285-5d
```


## bond port
http://blog.scottlowe.org/2012/10/19/link-aggregation-and-lacp-with-open-vswitch/
```
ovs-vsctl add-bond ovsbr1 bond0 eth1 eth3 lacp=active
ovs-appctl bond/show <bond name>
ovs-appctl lacp/show <bond name>
```
Check bond port
```
ovs-appctl bond/show
```

set the bond mode to [balance-slb](http://openvswitch.org/pipermail/dev/2011-July/010028.html)
```
ovs-vsctl set port bond0 bond_mode=balance-slb
```
> SLB bonding allows a limited form of load balancing without the remote switch's knowledge or cooperation.  The basics of SLB are simple.  SLB assigns each source MAC+VLAN pair to a link and transmits all packets  from that MAC+VLAN through that link.  Learning in the remote switch causes it to send packets to that MAC+VLAN through the same link.

## patch port
```
ovs-vsctl add-port br-ex patch-int
ovs-vsctl set interface patch-int type=patch
ovs-vsctl set interface <port name> options:peer=<peer name>
```

## vlan
```
ovs-vsctl set port eth0 vlan_mode=native-untagged trunks=0,11,33,44,55,66,99
```
native-untagged: accept both tagged and untagged packet  

clean port trunk
```
ovs-vsctl clear port eth0 trunks
ovs-vsctl set port eth0 trunks=[]
```

## fdb
show fdb table
```
[root@dog ~]# ovs-appctl fdb/show br-eth1
 port  VLAN  MAC                Age
    4  1500  90:e2:ba:68:e1:d0  202
    8  1100  fa:16:3e:00:5a:a0  146
    8  1100  fa:16:3e:c8:7a:34  122
    8  1100  fa:16:3e:8b:0c:2b   77
    4  1100  90:e2:ba:68:e1:d0   61
    8  1100  fa:16:3e:70:9c:27   11
    8  1100  fa:16:3e:64:7f:91    1
```    

flush fdb table
```
[root@dog ~]# ovs-appctl fdb/flush br-eth1
table successfully flushed
```

## set MAC aging time
The maximum number of seconds to retain a MAC learning entry for which no packets have been seen.  The default is currently 300 seconds (5 minutes).  The value, if specified, is forced into a reasonable range, currently 15 to 3600 seconds
```
ovs-vsctl --no-wait set bridge br-eth1  other_config:mac-aging-time=100
```

## set MAC table size
The maximum number of MAC addresses to learn.  The default is currently 2048.  The value, if specified, is forced into a reasonable range, currently 10 to 1,000,000.
```
ovs-vsctl --no-wait set bridge br-eth1  other_config:mac-table-size=100
```

##list bridge
```
[root@kvmnode002108 ~]# ovs-vsctl list-br
br-bond1
br-ha
br-int
```


# Flow
Open vSwitch uses different kinds of flows for different purposes:
- OpenFlow flows are the most important kind of flow. OpenFlow controllers use these flows to define a switch's policy. OpenFlow flows support wildcards, priorities, and multiple tables.  
When in-band control is in use, Open vSwitch sets up a few "hidden" flows, with priority higher than a controller or the user can configure, that are not visible via OpenFlow. (See the "Controller" section of the FAQ for more information about hidden flows.)

- The Open vSwitch software switch implementation uses a second kind of flow internally. These flows, called "datapath" or "kernel" flows, do not support priorities and comprise only a single table, which makes them suitable for caching. (Like OpenFlow flows, datapath flows do support wildcarding, in Open vSwitch 1.11 and later.) OpenFlow flows and datapath flows also support different actions and number ports differently.  
Datapath flows are an implementation detail that is subject to change in future versions of Open vSwitch. Even with the current version of Open vSwitch, hardware switch implementations do not necessarily use this architecture.

Users and controllers directly control only the OpenFlow flow table. Open vSwitch manages the datapath flow table itself, so users should not normally be concerned with it.

##show flows
Show all/hide flows
```
ovs-appctl bridge/dump-flows br-int
```

Show particular userpsace bridge datapath flows
```
ovs-appctl dpif/dump-flows <br>
```

Show all userspace bridges datapath flows
```
ovs-dpctl dump-flows
ovs-appctl dpif/show
```

Show datapath flow like `top`, get which port have biggest traffic.
```
ovs-dpctl-top
```

Show the name of each configured datapath
```
ovs-appctl dpif/dump-dps
system@br-bond1
system@br-int
```

Check flow limit/status
```
ovs-appctl upcall/show
system@ovs-system:
 flows         : (current 2) (avg 164) (max 16622) (limit 200000)
 dump duration : 2ms
```

## set flow limit
This command is only needed for advanced debugging. Max 200000, min 1000
```
ovs-appctl upcall/set-flow-limit 200000
```

##megaflows
Enable/disable megaflows
```
ovs-appctl upcall/enable-megaflows
ovs-appctl upcall/disable-megaflows
```
Check whether megaflows is enabled or not. The only way I know to check is by checking if the datapath flows include PORT parameters.
```
ovs-dpctl dump-flows|grep -E "udp|tcp"
```
##flow in datapath
Check flow hit/missed/lost
```
[root@dog ~]# ovs-dpctl show 
system@ovs-system:
        lookups: hit:14198854105 missed:1242464087 lost:1114150373
        flows: 1
        masks: hit:17458094925 total:3 hit/pkt:1.13
```
The  "lookups"  row  displays three stats related to flow lookup triggered by processing incoming packets in the datapath.  "hit" displays number of packets matches existing flows. "missed" displays the number of packets not matching any existing  flow  and require  user space processing.  "lost" displays number of packets destined for user space  process  but  subsequently  dropped before reaching userspace. The sum of "hit" and "miss" equals to the total number of packets datapath processed.

More about the "lost"  
http://openvswitch.org/pipermail/dev/2014-April/039213.html
Packets are being sent to userspace faster than they can be processed. This is usually because the packets have varying headers (e.g., a port scan) that cause misses in the exact-match flow cache in the kernel.

The "masks" row displays the mega flow mask stats. This  row  is omitted  for datapath not implementing mega flow. "hit" displays the total number of masks visited for matching incoming packets. "total" displays number of masks in the datapath. "hit/pkt" displays the average number of masks visited per packet; the ratio between "hit" and total number of packets processed by the datapath".

flow used:never  

It means that a packet has never matched that flow in the datapath. The packet that generated the flow was handled by ovs-vswitchd, so it's not accounted for in the datapath flow table.

Prints a summary of configured datapaths, including statistics and a list of connected ports. The port  information includes the OpenFlow port number, datapath port number, and the type.
```
ovs-appctl dpif/show
```

## trace flow
```
ovs-appctl ofproto/trace <flow>
```




# Database
##List database
```
[root@dog ~]# ovsdb-client list-dbs
Open_vSwitch
```
##List tables
```
[root@dog ~]# ovsdb-client dump | grep table
Bridge table
Controller table
Flow_Sample_Collector_Set table
Flow_Table table
IPFIX table
Interface table
Manager table
Mirror table
NetFlow table
Open_vSwitch table
Port table
QoS table
Queue table
SSL table
sFlow table
```

```
[root@dog ~]# ovsdb-client list-tables
Table                    
-------------------------
Port                     
Manager                  
Bridge                   
Interface                
SSL                      
IPFIX                    
Open_vSwitch             
Queue                    
NetFlow                  
Mirror                   
QoS                      
Controller               
Flow_Table               
sFlow                    
Flow_Sample_Collector_Set
```

```
[root@dog ~]# ovsdb-client list-columns Port
Column            Type                                                                                                 
----------------- -----------------------------------------------------------------------------------------------------
name              "string"                                                                                             
statistics        {"key":"string","max":"unlimited","min":0,"value":"integer"}                                         
vlan_mode         {"key":{"enum":["set",["access","native-tagged","native-untagged","trunk"]],"type":"string"},"min":0}
qos               {"key":{"refTable":"QoS","type":"uuid"},"min":0}                                                     
_uuid             "uuid"                                                                                               
trunks            {"key":{"maxInteger":4095,"minInteger":0,"type":"integer"},"max":4096,"min":0}                       
mac               {"key":"string","min":0}                                                                             
status            {"key":"string","max":"unlimited","min":0,"value":"string"}                                          
interfaces        {"key":{"refTable":"Interface","type":"uuid"},"max":"unlimited"}                                     
bond_active_slave {"key":"string","min":0}                                                                             
bond_downdelay    "integer"                                                                                            
_version          "uuid"                                                                                               
bond_mode         {"key":{"enum":["set",["active-backup","balance-slb","balance-tcp"]],"type":"string"},"min":0}       
bond_updelay      "integer"                                                                                            
external_ids      {"key":"string","max":"unlimited","min":0,"value":"string"}                                          
other_config      {"key":"string","max":"unlimited","min":0,"value":"string"}                                          
bond_fake_iface   "boolean"                                                                                            
tag               {"key":{"maxInteger":4095,"minInteger":0,"type":"integer"},"min":0}                                  
fake_bridge       "boolean"                                                                                            
lacp              {"key":{"enum":["set",["active","off","passive"]],"type":"string"},"min":0}                          
```

##List specific columns and specific target:
```
[root@dog ~]# ovs-vsctl --columns=name,other_config,tag list port tapd4b00ffc-bb
name                : "tapd4b00ffc-bb"
other_config        : {segmentation_id="1500"}
tag                 : 3
```

The schema:  modify it if want to add new tables `/usr/local/share/openvswitch/vswitch.ovsschema`  
The db instance: `/usr/local/etc/openvswitch/conf.db`

##数据库操作:
```
ovs-vsctl list/set/get/add/remove/clear/destroy table record column [value]
```

ovsdb-server与ovs-vswitchd通过 `/var/run/openvswitch/db.sock`通信。  
ovs-vswitchd通过和ovsdb-server修改数据库，ovs-vsctl大部门命令都是对数据库的操作。

##远程控制ovsdb-server
设置manager 
```
ovs-vsctl set-manager ptcp:8881
```

在另一台server上,配置目标server的db
```
ovs-vsctl --db=tcp:16.158.165.153:8881
```

# sflow
## Configure sflow
```
ovs-vsctl -- --id=@sflow create sflow agent=${AGENT_IP} target=\"${COLLECTOR_IP}:${COLLECTOR_PORT}\" header=${HEADER_BYTES} sampling=${SAMPLING_N} polling=${POLLING_SECS} -- set bridge br-int sflow=@sflow

[root@kvmnode002108 ~]# cat .sflow 
COLLECTOR_IP=10.27.248.3
COLLECTOR_PORT=6343
AGENT_IP=127.0.0.1
HEADER_BYTES=128
SAMPLING_N=64
POLLING_SECS=10
```

## list sflow configuration
```
[root@dog ~]# ovs-vsctl list sflow
_uuid               : 705b5f89-4d58-4777-86d9-e44fe81271db
agent               : "eth0"
external_ids        : {}
header              : 128
polling             : 10
sampling            : 512
targets             : ["10.24.74.73:6343"]
```

## delete sflow configuration
Check sflow belone to which bridge
```
[root@fish ~]# ovs-vsctl list bridge | grep sflow
sflow               : 20f8d4bf-e3f2-4235-bfce-b2c2689f7da8
sflow               : 3ecbe3cb-70fc-4a38-a657-e68c8acfca87
sflow               : []
```

Delete sflow from that bridge
```
[root@dog ~]# ovs-vsctl remove bridge br-int sflow 705b5f89-4d58-4777-86d9-e44fe81271db
```
OR
```
ovs-vsctl -- clear Bridge br-int sflow
ovs-vsctl -- clear Bridge br-bond1 sflow
```

# Controller
## fail mode
OpenvSwitch 在无法连接到控制器时候（fail mode）可以选择两种fail状态，一种是standalone，一种是secure状态。如果是配置了standalone（或者未设置fail mode）mode，在三次探测控制器连接不成功后，此时ovs-vswitchd将会接管转发逻辑（后台仍然尝试连接到控制器，一旦连接则退出fail状态），OpenvSwitch将作为一个正常的MAC-learning的二层交换机。如果是配置了secure mode，则ovs-vswitchd将不会自动配置新的转发流表，OpenvSwitch将按照原先有的流表转发。  可以通过下面命令进行管理。
```
ovs-vsctl get-fail-mode <bridge>
ovs-vsctl del-fail-mode <bridge>
ovs-vsctl set-fail-mode <bridge> <standalone|secure>
```

# debug
## show coverage counters
```
[root@fish ~]# ovs-appctl coverage/show 
Event coverage, avg rate over last: 5 seconds, last minute, last hour,  hash=f3e5372c:
nln_changed                0.0/sec     0.000/sec        0.0000/sec   total: 123
netlink_received          26.8/sec    26.083/sec       24.2886/sec   total: 11559962
netlink_recv_jumbo         0.0/sec     0.000/sec        0.0003/sec   total: 34
netlink_sent              25.6/sec    25.117/sec       23.5153/sec   total: 11153462
netdev_set_policing        0.0/sec     0.000/sec        0.0000/sec   total: 39
netdev_get_ifindex         0.0/sec     0.000/sec        0.0000/sec   total: 36
netdev_get_hwaddr          0.0/sec     0.000/sec        0.0000/sec   total: 36
netdev_set_hwaddr          0.0/sec     0.000/sec        0.0000/sec   total: 2
netdev_get_ethtool         0.0/sec     0.000/sec        0.0000/sec   total: 60
netdev_set_ethtool         0.0/sec     0.000/sec        0.0000/sec   total: 4
vconn_received             2.4/sec     2.400/sec        2.4822/sec   total: 726455
vconn_sent                 1.8/sec     1.800/sec        1.8617/sec   total: 544813
util_xalloc              1352.8/sec  1408.983/sec     1199.9022/sec   total: 556267078
unixctl_received           0.0/sec     0.033/sec        0.0006/sec   total: 11
```

## List logging levels
```
ovs-appctl vlog/list
```
## Configure debug logging

Syntax: vlog/set module[:facility[:level]]  
Module: any valid module name displayed by list option.  
Facility: must be one of the console, syslog, file  
Level: must be one of the emer, err, warn, info, or dbg.  

Note: Special name “ANY” can be used to set the logging levels for all modules and facility.



