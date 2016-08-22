Linux commands
=============================
Collection useful linux commands

##Check how long a process has run
With the `-o etimes` or `-o etime` parameter.  
`etime` show the time format with day-hour-minute-second.  
`etimes` show the time format with seconds.  
```sh
ps -p {PID-HERE} -o etime
ps -p {PID-HERE} -o etimes
```

