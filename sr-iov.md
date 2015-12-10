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

Check SR-IOV driver, igb is for 82576
```
[root@fish devices]# lsmod | grep igb
igbvf                  34514  0 
igb                   197536  0 
dca                     7101  1 igb
i2c_algo_bit            5935  1 igb
ptp                     9614  1 igb
i2c_core               31084  3 igb,i2c_algo_bit,i2c_i801
```