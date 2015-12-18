pdb
============================
Debug trips with pdb.

# set condition breakpointer
```
(Pdb) b 12
Breakpoint 1 at /root/deploy/p.py:12
(Pdb) b
Num Type         Disp Enb   Where
1   breakpoint   keep yes   at /root/deploy/p.py:12
(Pdb) condition 1 i==30
(Pdb) b
Num Type         Disp Enb   Where
1   breakpoint   keep yes   at /root/deploy/p.py:12
        stop only if i==30
```


