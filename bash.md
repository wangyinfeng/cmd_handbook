Bash tips
=========
#判断与循环

##for
```sh
for $var in list    #从list中依次取出参数执行；若list为空，则默认去所有参数·"$@")·
do
	......
done
```
操作一个目录中所有的文件
```
for file in $DIR/*
for file in [ab]*   #所有以a/b开头的文件
```
C风格
```
for ((i=1;i<=max;i++))
```
list参数带有两个单词的情况，如“hello world”, 使用`set -- $arg`可解析变量并设置位置参数，将多个单词设置为`$1`,`$2`...这样的位置参数。
不带list的情况，默认使用`$@`参数列表

##until
```
until [condition]   #condition满足即退出
do
	......
done
```

##while
```
while [condition]   #如果判断条件有多个，如逗号分隔的各条件，只有最后一个起决定性作用
do
	......
done
```
```
while true  #loop forever
do
    ......
done
```

##case
```
case $VAR in                 #不需显示break
yes|YES)
    ...... ;;
no|NO)
    ...... ;;
*)                            #default
    ......;;
    exit 1
esac
```

##if
```
if [condition]
then
	......
elif [condition]
then
	......
else
	......
fi
```
**[condition]**
```
-f     file exist
-d    directory exist
-r     readable
-w     writeable
-x     executable
-s     no zero length
-n     is string
-a     and
-o     or
-nt    new than 文件比较
-ot     old than
-ef     硬链接到同一个文件
-a     逻辑与
-o     逻辑或
-z `"$STRING"` / `-n "$STRING"` 判断字符串为空
```

##select
```
PS3=input your choice
select var in [list]
do
	...
break
done
```
如果无in [list] 则默认使用位置参数作为list

##break/continue
循环控制
```
break n #跳出n-level循环，默认跳出一层循环
continue n #跳过n-level循环，默认跳过一层循环
```

##比较
字符串比较与数值使用不同的操作符
###字符串比较：
```
"$VAR" = "FOX"     
"$VAR" != "FOX"
```
`-z` `"$VAR"` 字符串`$VAR`长度为0
`-n` `"$VAR"` 字符串`$VAR`长度为非0


###数值比较：
```
"$VAR" -eq 0 (=)     
-ne (!=)     
-le (<=)     
-lt (<)     
-ge (>=)     
-gt (>)     
```
###test/[]/[[]]/(())
`test`，`[` 均为shell内置命令，与`/usr/bin/test`，`/usr/bin/[` 作用一致。`]` 实际为`[` 的一个参数。
根据test后或括号内表达式返回结果(true/false)
test NULL/0/未定义变量/定义但未初始化的变量 结果为false

###检查文档属性(TRUE/FALSE)
```[ "$in" == "yes" ] && echo "OK" || "NOK"```
如果`[]`中test结果为TRUE，则执行`&&`之后的内容；如果`[]`中test结果为FALSE，则执行`||`之后的内容。

###shift 参数左移
```shift n``` 左移n个参数
对位置参数，shift 命令等同于以`$2`覆盖`$1`，`$1<-$2`

###循环中变量自增
```
let "i+=1"     
i = $[$i+1]     
i = 'expr $i+1'  
((i++))
```


#引用
引用的目的是避免变量被重新解释或扩展；

##`"` 
强/全引用，所有内容均不再被扩展/解释
```
string="hello world $name"
echo ‘$string’  -> hello world $name
```
若要保持变量的完整性，则需使用引用方式读取

##`""`
弱/部分引用，除`，\两个符号外，其他均不再扩展/解释。


防止单词分割，`""`中作为一个参数项，而非被空格分隔的多个参数。
```
string="hello world"
echo “$string”  -> hello world
echo $string -> hello
```
若变量中存在空格，则需要使用`""`引用

##{} 
1. 代码块
          `{}>result` 代码块内执行结果输出重定向
2. 变量扩展
          `cp file.{txt,back}  #等同于cp file.txt file.back`
3. `${}` 参数展开

##[]
1. test
2. 数组元素
3. 正则表达式字符范围

##()
1. 命令组  subshell运行时，其内部定义的变量为subshell局部变量
2. 数组初始化
3. `$()`命令展开

##`:[argument]`
1. 冒号表示这是一个空操作(NOP)，返回结果为true(0) .死循环，等同于 while true
	```
	while:
	do
	...
	done
	```
2. 做注释/参数扩展(变量替换). 变量扩展
          `:>data`
          清空文件，若文件不存在则创建。等同于`cat /dev/null > data`

##-
1. 重定向stdin OR stdout
2. 算术减号

##~
home目录
```
ls ~ABC #等同于 ls /home/ABC
```

#sed
```
sed -e /^$/d FILE     #删除空行. -e 表示可编辑
sed -e "s/$OLD/$NEW/g" FILE #  替换$OLD为$NEW
```

#string
## String contains substring
###Star Wildcard
```
if [[ "$string" == *"$substring"* ]]; then
    echo "'$string' contains '$substring'";
else
    echo "'$string' does not contain '$substring'";
fi
```

###Regular Expressions
```
if [[ "$string" =~ "$substring" ]]; then
    echo "'$string' contains '$substring'";
else
    echo "'$string' does not contain '$substring'";
fi
```
## check if a variable is a number
```
re='^[0-9]+$'
if ! [[ $yournumber =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi
```




