OVS command handbook
=========================


#Database command

```
[root@dog ~]# ovsdb-client list-dbs
Open_vSwitch
```

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

List specific columns and specific target:
```
[root@dog ~]# ovs-vsctl --columns=name,other_config,tag list port tapd4b00ffc-bb
name                : "tapd4b00ffc-bb"
other_config        : {segmentation_id="1500"}
tag                 : 3
```


