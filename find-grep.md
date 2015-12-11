find-grep
========================
# find
按FILENAME在PATH中查找 `find [PATH] -name FILENAME -print`  
查找PATH下最近100天没有使用过的程序 `find [PATH] -type f -atime +100 -print`  
查找[PATH]中24小时内修改过的文件 `find [PATH] -type f -mtime -1 -print`  
可以查询挂载的其他文件系统中的文件 `find [PATH] -name *.exe -printf -xdev`  
将find结果作为COMMAND的输入参数`find [PATH] -name FILENAME -exec COMMAND \`  

查找文件中字符串 `find $PATH -name "*" | xargs grep STRING`  OR `grep STRING $PATH -r`  
指定文件类型，查找字符串 `find . -name "*.c" -o -name "*.h*" | xargs grep -r "STRING"`  

# grep
grep exclude keyword `grep -v "unwanted_word" file | grep XXXXXXXX`

grep multiple patterns `grep -E 'word1|word2' *.txt`

查找多个关键字,KEY1或KEY2 `grep -r -E 'KEY1|KEY2'`  
KEY1 AND KEY2 `grep -r -E 'KEY1' ./* | grep 'KEY2'` 
-r 递归，-E：正则  -l：只显示文件名


