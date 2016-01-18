SR-IOV
========================
# Specification
http://redhatstackblog.redhat.com/2015/03/05/red-hat-enterprise-linux-openstack-platform-6-sr-iov-networking-part-i-understanding-the-basics/  
http://redhatstackblog.redhat.com/2015/04/29/red-hat-enterprise-linux-openstack-platform-6-sr-iov-networking-part-ii-walking-through-the-implementation/  
https://wiki.openstack.org/wiki/SR-IOV-Passthrough-For-Networking  
http://docs.openstack.org/networking-guide/adv_config_sriov.html  

SR-IOV...Allocating a VF to a virtual machine instance enables network traffic to **bypass the software layer of the hypervisor** and flow directly between the VF and the virtual machine... a near line-rate performance.

The overall bandwidth available to the PF is **shared** between all VFs associated with it.

the network adapter must provide support for SR-IOV and implement some form of hardware-based Virtual Ethernet Bridge (VEB). 

With the introduction of SR-IOV networking support, it is now possible to associate a Neutron port with a Virtual Function that resides on the network adapter. For those Neutron ports, a virtual bridge on the Compute node is no longer required.

When a packet comes in to the physical port on the network adapter, it is **placed into a specific VF pool based on the MAC address or VLAN tag**. This lends to a direct memory access transfer of packets to and from the virtual machine. The **hypervisor is not involved** in the packet processing to move the packet, thus removing bottlenecks in the path. Virtual machine instances using SR-IOV ports and virtual machine instances using regular ports (e.g., linked to Open vSwitch bridge) can communicate with each other across the network as long as the appropriate configuration (i.e., flat, VLAN) is in place.

SR-IOV support is required on several layers on the Compute node, namely the BIOS(VT-d), the base operating system, and the physical network adapter.

Neutron security groups cannot be used with SR-IOV enabled instances.

Vendors: Intel, Broadcom, Mellanox and Emulex.

## issues
the ability to plug/unplug a SR-IOV port on the fly which is currently not available

Live Migration support. An SR-IOV Neutron port may be directly connected to its VF as shown above (vnic_type ‘direct’) or it may be connected with a macvtap device that resides on the Compute (vnic_type ‘macvtap’), which is then connected to the corresponding VF. The macvtap option provides a baseline for implementing Live Migration for SR-IOV enabled instances. 

# Enable SR-IOV driver
`lspci` to check the ethernet card type, 82576 and I350 both support SR-IOV.
```
[root@fish devices]# lspci | grep Ethernet
07:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
07:00.1 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
82:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
82:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
```

#Check the ethX is belong to which PCI device
```
[root@fish ~]# systool -c net
Class = "net"

  Class Device = "eth0"
    Device = "0000:07:00.0"

  Class Device = "eth1"
    Device = "0000:07:00.1"

  Class Device = "eth2"
    Device = "0000:82:00.0"

  Class Device = "eth3"
    Device = "0000:82:00.1"

  Class Device = "lo"

```

#Get the VF's vendor id and product id 
```
[root@fish neutron]# lspci -nn | grep -i ethernet
07:00.0 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev 01)
07:00.1 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev 01)
82:00.0 Ethernet controller [0200]: Intel Corporation 82576 Gigabit Network Connection [8086:10c9] (rev 01)
82:00.1 Ethernet controller [0200]: Intel Corporation 82576 Gigabit Network Connection [8086:10c9] (rev 01)
82:10.0 Ethernet controller [0200]: Intel Corporation 82576 Virtual Function [8086:10ca] (rev 01)
82:10.2 Ethernet controller [0200]: Intel Corporation 82576 Virtual Function [8086:10ca] (rev 01)
```
For the above case, the vendor id is `8086` and product id is `10ca`.


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


