pdb
============================
Debug trips with pdb.
# enable pdb debug
Use `-m pdb` to import pdb module, and break before running.
```
python -m pdb myscript.py
```

OR import the pdb module in the code
```
import pdb
...
pdb.set_trace()
...
```

# set condition breakpointer
b bpnumber [condition]
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

# set variable value
use `!key=value`
```
(Pdb) !i=20 
(Pdb) p i
20
```

