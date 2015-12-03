OVS command
=========================
# port
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
ovs-appctl bond/show br-bond0
```

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
[root@dog ~]# ovs-appctl fdb/flush
table successfully flushed
```

##list bridge
```
[root@kvmnode002108 ~]# ovs-vsctl list-br
br-bond1
br-ha
br-int
```
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

# Flow
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






