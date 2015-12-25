sybase
===========================
Operation tips for sybase



版本
Developer  Edition，简称DE，这是个开发版，不需要license，可长久使用，只不过有些功能使用受限。
Express     Edition，简称XE，这是个快速版，不需要license，可长久使用，只不过有些功能使用受限。
Enterprise Edition，简称EE，这是个企业版，不安装license的情况下，只有一个月的使用期，无license的这一个月期间，所有功能都可以用。

启动停止
startserver -f NAME
isql -Usa -P -SNAME
>shutdown
>go

查看及配置端口
/home/sybase/interfaces

设置
1.内存
sp_configure "max memory",1500000 重启生效（设置为共享内存的75%）
sp_configure "allocate max shared mem",1 启动的时候自动分配max memory指定的最大
内存
sp_cacheconfig "default data cache","1500m" 设置数据缓存（设置为max memory的一半
）
sp_cacheconfig "default data cache","cache_partition=2" 是CPU数量的倍数,对数据缓冲区分区
sp_poolconfig "default data cache","64m","16k" 设置16K 数据缓存
sp_poolconfig "default data cache","128m","8k" 设置8K 数据缓存
sp_configure "procedure cache size",90000 存储过程数据缓存sp_cacheconfig 'tempd
b_cache','200m','mixed' 创建命名高速缓存sp_bindcache 'tempdb_cache',tempdb 捆绑临时数据库到tempdb_cache高速缓存
2.cpu
sp_configure "max online engines",2 设置使用的CPU数量
sp_configure "number of engines at startup",2 启动时使用CPU数量
3. 网络
sp_configure "default network packet size",2048 设置网络传送包的大小(重启动生效)
sp_configure "max network packet size",2048
4. 其他资源使用
sp_configure "number of locks",100000 锁使用数量
sp_configure "number of open indexes",5000 打开索引
sp_configure "number of open objects",5000 打开对象
sp_configure "number of user connections",1000 用户连接数
sp_configure "number of device",100 新建设备最大数量
sp_helpdevice 查看数据库设备
sp_helpdb 查看数据库

执行数据库脚本
isql -Usa -Ppassword -Sserver_name -i scripts.sql -o err.out

插入删除记录
insert table values(1,17,17,1,2,1,0,123,4,1,'haha',0,0)
delete from table where asid=17

更新记录
update table set val=123 where id=1

like 字符串模糊匹配
select * from table where name like '%wang%'

新建数据设备及数据库
disk init name="versiondb_dev",physname="/home/sybase/data/versiondb_dev.dat",size=50000 (2k page为单位)
disk init name="versiondb_log",physname="/home/sybase/data/versiondb_log.dat",size=50000
disk init name="zxin_dev",physname="/home/sybase/data/zxin_dev.dat",size=1000000
disk init name="zxin_log",physname="/home/sybase/data/zxin_log.dat",size=1000000
create database versiondb on versiondb_dev=100 log on versiondb_log=100 (MB为单位)
create database zxin on zxin_dev=400 log on zxin_log=400
create database zxinsys on zxin_dev=400 log on zxin_log=400
create database zxinalarm on zxin_dev=500 log on zxin_log=500
create database zxinmeasure on zxin_dev=500 log on zxin_log=500

 步骤:
 a.      用disk init初始化二个数据库设备:一是数据库数据设备,二是日志设备
         1>disk init name=逻辑设备名,
         2>physname=“物理设备名”,
         3>size=页个数(2K为单位)
 b.      用create database创建用户数据库
        1>create database 用户数据库名
        2>on 数据设备逻辑名=大小(M为单位)
        3>log on日志设备逻辑名=大小(M为单位)


查看数据库空余空间
>sp_helpdb dbname

增加数据库大小
查看数据库大小等信息： 
> sp_helpdb NAME

查看vdevno等信息：
>sp_helpdevice

> disk init name="versiondb3",physname="/home/sybase/data/versiondb3",vdevno=20
,size=100000
> alter database versiondb on versiondb2=100000
> go

增加log空间大小
 > alter database versiondb log on versiondb2=100000

清除数据库日志
> dump transaction versiondb with truncate_only
> dump transaction versiondb with no_log

删除数据库
 drop database DATABASE
 sp_dropdevice DEVICENAME

备份恢复
备份数据库的语法为：
dump database database_name to dump_device

恢复用户数据库
load database database_name from file_name

修改servername.cfg
重启SYBASE

查看数据库支持的字符集
1> sp_helpsort
Sort Order Description
                                                                   
------------------------------------------------------------------
Character Set = 190, utf8                                         
     Unicode 3.1 UTF-8 Character Set                               
     Class 2 Character Set                                         
Sort Order = 50, bin_utf8                                         
     Binary sort order for the ISO 10646-1, UTF-8 multibyte encodin
     g character set (utf8).

客户端字符集
1> select @@client_csname
2> go
                               
------------------------------
iso_1                         

查看一个数据库中所有表名
select * from sysobjects

删除一个表中所有记录
truncate table from TABLENAME





