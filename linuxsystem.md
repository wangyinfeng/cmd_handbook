Linux system configuration
======================================
Configuration tips for Linux system.


#运行级别
操作系统当前的功能级别。在/etc/inittab中指定。

0 – halt(DO NOT set initdefault to this)
1 – Single user mode
2 – Mutiuser,without NFS
3 – Full mutiuser mode
4 – unused
5 – X11 (远程gui登陆需要设置为这个运行级别)
6 – reboot(DO NOT set initdefault to this)
最先运行的是位于/etc/rc.d下的文件，启动脚本一般位于/etc/rc.d/init.d中，这些脚本被用ln连接到/etc/rc.d/rcn.d，(n表示运行级别0~6)。

##运行级别的配置
15:5:wait:/etc/rc.d/rc 5
第一个字段为一个任意标示；第二个字段表示运行级别(5)，第三个字段表示init等待第四个字段的命令运行结束(wait)。 第四个字段做实际工作，启动没有运行的服务，停止该运行级别下不该有的服务。

单用户模式可以在丢失root口令情况下使用passwd重新设定root口令。

具体参考info inittab或man inittab。

#linux kernel参数配置
##显示消息队列配置
```
sysctl -a | grep kernel.msg*
```

##配置核心参数
`/etc/sysctl.conf`
生效：
```
inserv boot.sysctl
/etc/init.d/boot.sysctl start
```

##Linux系统时间修改
Linux下一般使用`date -s`命令来修改系统时间。  
如将系统时间设定成1999年12月9日的命令如下：`date -s 12/09/99`  
将系统时间设定成下午2点18分9秒的命令如下：`date -s 14:18:09`  
注意，这里说的是系统时间，是linux由操作系统维护的。  
在系统启动时，Linux操作系统将时间从CMOS中读到系统时间变量中，以后修改时间通过修改系统时间实现。为了保持系统时间与CMOS时间的一致性，Linux每隔一段时间会将系统时间写入CMOS。由于该同步是每隔一段时间（大约是11分钟）进行的，在我们执行date -s后，如果马上重起机器，修改时间就有可能没有被写入CMOS,这就是问题的原因。如果要确保修改生效可以执行如下命令 `clock -w`

#samba服务
service smb start/ /etc/init.d/smb start/ Yast(suse) smbservice configure
     启动samba服务

sambastatus/chkconfig smb
     查看samba服务

smbmount/smbumount   
     加载/卸载samba服务

smbclient -l //LOCALHOST
     查看本地共享

smbclient //IPADDRESS/share_dir -u username     OR
mount -t smbs username=USER, passwords=PASSWORD //IPADDRESS/share_dir $HOME/SHARE
     访问共享文件夹

XDM服务开启在Suse上配置远程图形登录(xdmcp)支持需要下面4个步骤：
1. 修改/etc/X11/xdm/Xaccess，设置哪些主机可以连接X
#* # any host can get a login window
去掉#
2. 修改/etc/sysconfig/displaymanager
确认displaymanager为kdm
DISPLAYMANAGER="kdm"
DISPLAYMANAGER_REMOTE_ACCESS="yes"

3. 修改/etc/opt/kde3/share/config/kdm/kdmrc      (KDE)
/etc/opt/gnome/gdm/gdm.conf                      (GNOME)
( RedHat:/etc/X11/gdm/gdm.conf )
[Xdmcp]([xdmcp])段
Enable=true ，如果没有则添上'Enable=true'

4. 启用并重启xdm
# insserv xdm
# rcxdm restart
( # /etc/init.d/xdm restart )

服务器访问控制
/etc/hosts.allow和/etc/hosts.deny
这两个文件是tcpd服务器的配置文件，tcpd服务器可以控制外部IP对本机服务的访问。这两个配置文件的格式如下：
#服务进程名:主机列表:当规则匹配时可选的命令操作
server_name:hosts-list[:command]
/etc/hosts.allow控制可以访问本机的IP地址，/etc/hosts.deny控制禁止访问本机的IP。如果两个文件的配置有冲突，以/etc/hosts.deny为准。下面是一个/etc/hosts.allow的示例：
ALL:127.0.0.1         #允许本机访问本机所有服务进程
smbd:192.168.0.0/255.255.255.0     #允许192.168.0.网段的IP访问smbd服务
ALL关键字匹配所有情况，EXCEPT匹配除了某些项之外的情况，PARANOID匹配你想控制的IP地址和它的域名不匹配时(域名伪装)的情况。

/etc/ftpusers
配置登录用户限制

/etc/issue.net
/etc/motd
设置远程登录界面提示信息
issue.net用于登录前提示信息
motd用于登录后提示信息


这个命令强制把系统时间写入CMOS

获取时间API
time() 返回timeval.tv_sec 秒数
settime() 设置时间
gettimeofday() 返回us精度级别
settimeofday()
cat /proc/uptime     显示系统启动时间以及cpu idle时间
uptime     显示系统启动时间，用户数量以及1/5/15分钟的平均负荷

xtime     计算自1970-01-01 00:00:00的相对秒数
jiffies     tick number since system up
uptime     time since system up

Linux系统时间生成
HardwareTimer(RTC) -> tick -> walltime/up time

##自启动管理

###开机自启动

Linux加载后,运行第一个进程init。init根据配置文件继续引导过程，启动其它进程。 通常情况下，修改放置在 /etc/rc，/etc/rc.d或/etc/rc.d/rc.local或/etc/rcN.d目录下的脚本文件， 可以使init自动启动其它程序。例如：
```
vim /etc/rc.d/rc.loacl
........
/usr/bin/MYPROGRAMME  [option]
........
```

###登录自启动

用户登录时，bash首先自动执行系统管理员建立的全局登录script：`/ect/profile`。 然后bash在用户起始目录下按顺序查找三个特殊文件中的一个：`/.bash_profile`、`/.bash_login`、`/.profile`， 但只执行最先找到的一个。只需根据实际需要在上述文件中加入命令就可以实现用户登录时自动运行某些程序。

###退出自动运行

退出登录时，bash自动执行个人的退出登录脚本`/.bash_logout`。 例如：

```
vim /.bash_logout
...............
tar －cvzf c.source.tgz *.c #退出登录时自动执行 "tar" 备份 *.c 文件。
...............
```
###定期自动运行

Linux有一个称为crond的守护程序，主要功能是周期性地检查 `/var/spool/cron`目录下的一组命令文件的内容， 并在设定的时间执行这些文件中的命令。用户可以通过`crontab` 命令来建立、修改、删除这些命令文件。

###定时自动运行程序 –– 一次

定时执行命令at 与crond 类似（但它只执行一次）：命令在给定的时间执行，但不自动重复。 at命令的一般格式为：at [ －f file ] time ，在指定的时间执行file文件中所给出的所有命令。 也可直接从键盘输入命令：
```
  $ at 12:00
  at>mailto Roger －s ″Have a lunch″ < plan.txt
  at>Ctr－D
  Job 1 at 2007－04－09 12:00
```
在2007－04－09 12:00时候自动发一标题为“Have a lunch”，内容为plan.txt文件内容的邮件给Roger。

##RedHat单网卡多IP
例：将eht0 添加新地址 eth0:1
1.  拷贝/etc/sysconfig/network-scripts/ifcfg-eth0文件为ifcfg-eth0:1
2.  修改其中DEVICE=eth0:1
3.  根据需要修改IP地址(IPADD)和掩码（NETMASK）,可以删除NETWORK、BROADCAST、HWADDR
4.  重启网络服务#service network restart
route add default gw xxx.xxx.xxx.xxx netmask xxx.xxx.xxx.xxx
Check ethernet interface status

	* cat /sys/class/net/ethX/operstate
	* dmesg | grep eth
	* ethtool ethX

##Change the NIC name
editing /etc/default/grub and adding "net.ifnames=0" to GRUB_CMDLINE_LINUX variable.
Then run regenerate GRUB configuration with updated kernel parameters.
$ grub2-mkconfig -o /boot/grub2/grub.cfg
Next, edit (or create) a udev network naming rule file (/etc/udev/rules.d/70-persistent-net.rules), and add the following line. Replace MAC address and interface with your own.
$ vi /etc/udev/rules.d/70-persistent-net.rules
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="08:00:27:a9:7a:e1", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
Then reboot

##代理配置
First of all, you need a proxy server...

###yum配置代理
```
echo "proxy=http://192.168.255.130:655" >> /etc/yum.conf
```

###wget配置代理
```
[root@ ~]# cat .wgetrc 
http_proxy = http://192.168.255.130:655
ftp_proxy = http://192.168.255.130:655
use_proxy = on
wait = 15
```
