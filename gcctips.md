gcc
========================

编译过程分为Pre-processing,compiling,assembling,linking四个阶段。

gcc参数  
* -E: 只进行pre-processing处理
* -o: 产生目标文件
* -i: 选择要使用到的linker库
* -c: 编译，不link
* -g: debug，包含symbol信息，release版本不含symbol信息
* -Wall: 显示所有warning
* -Wextra: show more warning, such as compare pointer with number, missing parameter type
* -Wfloat-equal: show warning if compare float number with == or !=
* -save-temps: save all temporary files
* @file: save the options in file and type less words. eg: gcc @options hello.c -o hello

readelf
     查看elf文件内容
nm 
     列出symbol
objdump -S
     反汇编目标文件

GCC -O选项
这个选项控制所有的优化等级。使用优化选项会使编译过程耗费更多的时间，并且占用更多的内存，尤其是在提高优化等级的时候。 
-O设置一共有五种：-O0、-O1、-O2、-O3和-Os。
-O0：关闭所有优化选项，也是CFLAGS或CXXFLAGS中没有设置-O等级时的默认等级。 
-O1：基本的优化等级。编译器会在不花费太多编译时间的同时试图生成更快更小的代码。这些优化是非常基础的，但一般这些任务肯定能顺利完成。 
-O2：推荐的优化等级，除非你有特殊的需求。-O2会比-O1启用多一些标记。设置了-O2后，编译器会试图提高代码性能而不会增大体积和大量占用的编译时间。 
-O3：最高最危险的优化等级。用这个选项会延长编译代码的时间，并且在使用gcc4.x的系统里不应全局启用。自从3.x版本以来gcc的行为已经有了极大地改变。在3.x，-O3生成的代码也只是比-O2快一点点而已，而gcc4.x中还未必更快。用-O3来编译所有的软件包将产生更大体积更耗内存的二进制文件，大大增加编译失败的机会或不可预知的程序行为（包括错误）。这样做将得不偿失，记住过犹不及。在gcc 4.x.中使用-O3是不推荐的。 
-Os：这个等级用来优化代码尺寸。其中启用了-O2中不会增加磁盘空间占用的代码生成选项。这对于磁盘空间极其紧张或者CPU缓存较小的机器非常有用。但也可能产生些许问题，因此软件树中的大部分ebuild都过滤掉这个等级的优化。使用-Os是不推荐的。

GCC -g选项
如果不打开-g或者-ggdb(GDB专用)调试开关，GCC编译时不会加入调试信息，因为这会增大生成代码的体积。
GCC采用了分级调试，通过在-g选项后附加数字1、2或3来指定在代码中加入调试信息量。默认的级别是2（-g2），此时调试信息包括扩展的符号表、行号、局部或外部变量信息。级别3（- g3）包含级别2中的调试信息和源代码中定义的宏。级别1（-g1）不包含局部变量和与行号有关的调试信息，只能用于回溯跟踪和堆栈转储之用。回溯跟踪指的是监视程序在运行过程中的函数调用历史，堆栈转储则是一种以原始的十六进制格式保存程序执行环境的方法，两者都是经常用到的调试手段。


 



