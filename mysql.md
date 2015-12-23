mysql
========================================

数据库导出/恢复
http://www.cnblogs.com/xuejie/archive/2013/01/11/2856911.html
导出
mysqldump -u wcnc -p -d --add-drop-table smgp_apps_wcnc >d:\wcnc_db.sql
#-d 不导出数据只导出结构 --add-drop-table 在每个create语句之前增加一个drop table

mysqldump -uusername -ppassword databasename > backupfile.sql

mysqldump -uusername -ppassword databasename specific_table1 specific_table2 > backupfile.sql

mysqldump –all-databases > allbackupfile.sql

恢复
mysql -hhostname -uusername -ppassword databasename < backupfile.sql

导入数据库，常用source 命令
#进入mysql数据库控制台，
mysql -u root -p
mysql>use 数据库
mysql>set names utf8; （先确认编码，如果不设置可能会出现乱码，注意不是UTF-8）
mysql>source d:\wcnc_db.sql


