高亮多个关键字

高亮第二个关键字，用match命令可以完成，输入“:match ErrorMsg /keyword2/”命令，
高亮第三个关键字，输入":2match Title /keyword3/"，
高亮第n个关键字。要知道系统还有哪些内置的颜色即可，这个很好办，只需执行":hi"命令即可查询到，查询到后只需要执行“:nmatch XXX /keywordn/”。
取消高亮用 :nmatch none，其中 n=1、2、3等
