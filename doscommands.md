DOS commands
=========================

##subst　路径替换
 [用法］subst 　　显示当前的替代路径
　　　　　　　　subst [盘符] [路径]　　　　　　　　　　　　　　　　　　　　
　　　　　　　　将指定的[路径]替代[盘符]，该路径将作为驱动器使用
　　　　　　　　subst /b　　　　　　　　　解除替代
［例子］C:\DOS>subst a: c:\temp   用c盘temp目录替代a盘
　　　　　　　　C:\>subst a: /d  　　　　　解除替代 

##md      make directory
     md 1\2\3     可直接创建多层目录

##rd     remove directory
     /s     删除包括子目录时不需要确认
     /q     quiet mode

##ren(rename)     rename file

##del
     /p     确认删除
     /f     强制删除
     /s     从所有子目录删除文件
     /q     quiet mod

##xcopy source destination
     /e     复制目录及子目录，包括空目录
     /s     复制目录及子目录，除了空目录
     /c     忽略错误
     /i     若目标不存在，复制一个以上文件，则假定目标是一个目录
     /h     复制隐藏文件和系统文件
     /u     只复制已存在目标文件夹中存在的文件
     /k     复制保留属性
     /y     禁止提示文件重复

##循环
for /l %%i in (1,1,100) do (
command
)
i从1到100步进1执行command

##判断
文件是否存在  if exist FILE
字符串是否相等 if "strA"=="strB"  使用 /I 参数不区分大小写
数值是否相等 if numA equ numB
变量是否赋值 if defined VAL

##数值比较
equ  =
gtr   >
geq  >=
lss   <
leq  <=
neq !=

if-else必须在同一行，若分行，则用^符号连接
if [] (
......
) else (
......
)
或
if [] (
......) ^
else 
(
......
)
     
##延时
`ping 127.0.0.1 -n 1000 >nul` 执行空命令延时的一种方法，1000表示1分钟

##变量
初始化变量： `set val=value`  
引用： `echo %val%`

##预定义变量
`%CD%` 当前目录字符串  
`%DATE%` 日期  
`%TIME%` 时间  
`%RANDOM%` 0～32767之间的十进制数值  
`%path%` 环境变量  
`%1～%9` 命令行参数(位置参数), 访问超过9个的参数，必须使用shift命令  
`%0` 当前运行脚本名  
`%*` 所有参数  
 

