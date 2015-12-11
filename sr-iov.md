SR-IOV
========================
# Specification
SR-IOV...Allocating a VF to a virtual machine instance enables network traffic to bypass the software layer of the hypervisor and flow directly between the VF and the virtual machine... a near line-rate performance.

The overall bandwidth available to the PF is shared between all VFs associated with it.

Vendors: Intel, Broadcom, Mellanox and Emulex.

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

Another way is 
```
modprobe -r igb
modprobe igb max_vfs=7
```
**Remove the dirver will make the ethernet card unavaliable. And this way will effect all cards.**

List VF device
```
[root@fish devices]# virsh nodedev-list | grep 0000_82_10  
pci_0000_82_10_1
[root@fish devices]# virsh nodedev-dumpxml pci_0000_82_10_1
<device>
  <name>pci_0000_82_10_1</name>
  <path>/sys/devices/pci0000:80/0000:80:01.0/0000:82:10.1</path>
  <parent>pci_0000_80_01_0</parent>
  <driver>
    <name>igbvf</name>
  </driver>
  <capability type='pci'>
    <domain>0</domain>
    <bus>130</bus>
    <slot>16</slot>
    <function>1</function>
    <product id='0x10ca'>82576 Virtual Function</product>
    <vendor id='0x8086'>Intel Corporation</vendor>
    <capability type='phys_function'>
      <address domain='0x0000' bus='0x82' slot='0x00' function='0x1'/>
    </capability>
  </capability>
</device>
```


