oracle
=========================
oracle operation tips

查看用户信息
```
lsnrctl
```

查看实例
```
>select * from dba_users
```

查看当前用户表信息
```
>select * from v$database;
>select * from v$instance;
```

查看表空间使用情况
```
>select * from user_users

>SELECT   a.tablespace_name   "Tablespace name",total/1024/1024   "size(M)",free/1024/1024   "free(M)",  (total-free)/1024/1024   "used(M)",   ROUND((total-free)/total,4)*100   "usage %"  FROM     (SELECT   tablespace_name,SUM(bytes)   free   FROM   DBA_FREE_SPACE   GROUP   BY   tablespace_name)   a,   (SELECT   tablespace_name,SUM(bytes)   total   FROM   DBA_DATA_FILES   GROUP   BY   tablespace_name)   b   WHERE   a.tablespace_name=b.tablespace_name;
```

默认管理用户登录
```
# sqlplus system/manager
```

登录到相应库
```
# sqlplus zxinsys/zxinsys@zxin
```

修改库密码:
```
# sqlplus system/manager
> alter user zxinsys identified by zxinsys;
> commit;
```

执行脚本
```
sqlplus user/password@instancename< /home/sql/sqlfile.sql
```
or
```
cat sqlfile.sql | sqlplus user/password@instancename
```
or
```
sqlplus /nolog
>connect user/password@instancename
>start /home/sql/sqlfile.sql
```
or
```
sqlplus /nolog
>connect user/password@instancename
>@/home/sql/sqlfile.sql
```

创建tablespace
```
CREATE [UNDO] TABLESPACE tablespace_name
[DATAFILE datefile_spec1 [,datefile_spec2] ......
[ { MININUM EXTENT integer [k|m]
| BLOCKSIZE integer [k]
|logging clause
|FORCE LOGGING
|DEFAULT {data_segment_compression} storage_clause
|[online|offline]
|[PERMANENT|TEMPORARY]
|extent_manager_clause
|segment_manager_clause}]
```
EXAMPLE:
```
CREATE TABLESPACE "SIGTRAN" NOLOGGING DATAFILE '$ORACLE_DATA/sigtrandb.dbf' SIZ
E 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT  AUTO;
```
删除tablespace
```
DROP TABLESPACE SIGTRAN INCLUDING CONTENTS AND DATAFILES
```

增加数据文件尺寸
```
ALTER DATABASE DATAFILE 'sigtrandb.dbf' RESIZE 4000M;
```

命令行查看脚本运行结果
```
show error
```

赋予表权限给某用户
```
grant all on db.table to USER
```


