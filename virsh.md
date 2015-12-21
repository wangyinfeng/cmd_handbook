virsh
============================
Commands collection for virsh

show running VMs
virsh list

show all define VMs
virsh list --all

create a new VM
virsh define ABC.xml

stop a VM
virsh destroy ABC

delete a VM, will delete both image and xml files
virsh undefine ABC

start VM
virsh start ABC

[Clone VM](http://www.havetheknowhow.com/Configure-the-server/KVM-clone-a-vm.html)
virt-clone -o OriginalVMname -n NewVMname -f /var/libvirt/image/new_vm.img

#Issues
Install ubuntu on Centos7, change the bridge to OVS br-int, error message reported： unable to add bridge br0 port vnet0 operation not supported

Add the virtual port to the VM configure file, 
virsh edit <vm>
<virtualport type='openvswitch'>




