Linux system configuration
======================================

Linux系统时间修改
Linux下一般使用“date -s”命令来修改系统时间。
如将系统时间设定成1999年12月9日的命令如下：#date -s 12/09/99
将系统时间设定成下午2点18分9秒的命令如下：#date -s 14:18:09
注意，这里说的是系统时间，是linux由操作系统维护的。
在系统启动时，Linux操作系统将时间从CMOS中读到系统时间变量中，以后修改时间通过修改系统时间实现。为了保持系统时间与CMOS时间的一致性，Linux每隔一段时间会将系统时间写入CMOS。由于该同步是每隔一段时间（大约是11分钟）进行的，在我们执行date -s后，如果马上重起机器，修改时间就有可能没有被写入CMOS,这就是问题的原因。如果要确保修改生效可以执行如下命令。
#clock -w 

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



