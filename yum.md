yum and rpm
==================================
#yum
## ignore dependency

## uninstall packet

## find the header file installed by which packet
```
yum whatprovides "*/include/linux/autoconf.h"
```

##search packages name with STRING
```
yum search STRING
```

##list repository
```
yum repolist 
```
     Not all packages(libnet) are available in the list, the EPEL need to add by manual for CentOS, refer to Enable EPEL repository

## install repository     
To Install Sourceforge repository use below download links.
CentOS/RHEL 6, 64 Bit (x86_64):
```
# rpm -Uvh http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
```

To Install EPEL repository use below download links.
CentOS/RHEL 6, 64 Bit x86_64):
```
# rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
```
     


#rpm 
## uninstall packet
```
rpm -e packet
rpm -e --nodeps packet   #ignore dependency
```



