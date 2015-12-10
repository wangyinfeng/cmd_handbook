SR-IOV
========================
# Enable SR-IOV driver
`lspci` to check the ethernet card type, 82576 and I350 both support SR-IOV.
```
[root@fish devices]# lspci | grep Ethernet
07:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
07:00.1 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
82:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
82:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
```

Check SR-IOV driver, igb is for 82576, different NIC has different driver.
```
[root@fish devices]# lsmod | grep igb
igbvf                  34514  0 
igb                   197536  0 
dca                     7101  1 igb
i2c_algo_bit            5935  1 igb
ptp                     9614  1 igb
i2c_core               31084  3 igb,i2c_algo_bit,i2c_i801
```

Set SR-IOV
```
[root@fish devices]# echo 1 > /sys/bus/pci/devices/0000\:82\:00.1/sriov_numvfs 
[root@fish devices]# lspci | grep Ethernet
07:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
07:00.1 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
82:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
82:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
82:10.1 Ethernet controller: Intel Corporation 82576 Virtual Function (rev 01)
```