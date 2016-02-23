yum and rpm
==================================
#yum
## ignore dependency

## uninstall packet

## find the header file installed by which packet
```
yum whatprovides "*/include/linux/autoconf.h"
```

#rpm 
## uninstall packet
```
rpm -e packet
rpm -e --nodeps packet   #ignore dependency
```



