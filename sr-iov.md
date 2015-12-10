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


