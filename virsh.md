virsh
============================
Commands collection for virsh

`virsh list` show running VMs

`virsh list --all` show all define VMs

`virsh define ABC.xml` create a new VM

`virsh destroy ABC` stop a VM

`virsh undefine ABC` delete a VM, will delete both image and xml files

`virsh start ABC` start VM

`virt-clone -o OriginalVMname -n NewVMname -f /var/libvirt/image/new_vm.img` [Clone VM](http://www.havetheknowhow.com/Configure-the-server/KVM-clone-a-vm.html)

#Issues
Install ubuntu on Centos7, change the bridge to OVS br-int, error message reported： 
`unable to add bridge br0 port vnet0 operation not supported`

Solution  
Add the virtual port to the VM configure file, 
```
virsh edit <vm>
<virtualport type='openvswitch'>
```

# add device

Edit the device configure file
```
   <interface type='hostdev' managed='yes'>
     <source>
       <address type='pci' domain='0' bus='11' slot='16' function='0'/>
     </source>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
   </interface>
```
Add the device by `attach-device` command.
```
virsh attach-device MyGuest /tmp/new-interface.xml  --config
```


