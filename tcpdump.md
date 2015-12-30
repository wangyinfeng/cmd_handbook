tcpdump
================================
# Parameters
Do not resolve IP to NAME
> -n     Don’t convert host addresses to names.  This can be used to avoid DNS lookups.

Also do not resolve the port name
> -nn    Don’t convert protocol and port numbers etc. to names either.

Specify the buffer size
> -B SIZE



# issues
## packets dropped by kernel
What's the `packets dropped by kernel`?
```
1537 packets captured
2023 packets received by filter
477 packets dropped by kernel
```
> packets dropped by kernel" (this is the number of packets that were dropped, due to a lack of buffer space, by the packet capture mechanism in the OS on which tcpdump is running, if the OS reports that information to applications; if not, it will be reported as 0).

Set the buffer size with `tcpdump -B 4096`, the unit is KB.

## where does the packets be captured
[Between kernel stack and device driver.](http://www.cubrid.org/blog/dev-platform/understanding-tcp-ip-network-stack/)

[TCPdump hooks above the driver, and does not see what is sent on the wire. Rather it sees what is sent from the stack to the driver.](https://www.myricom.com/software/myri10ge/349-when-i-view-traffic-with-tcpdump-why-do-i-see-packets-larger-than-the-mtu.html)

## Can not capture some packet
Sometimes when do tcpdump for ping packet, can't capture the icmp packet on the physical interface.  
For example `tcpdump -i eth1 icmp` has no captured result. It's because the packet is encapsulated in VLAN. Packets can be captured by `tcpdump -i eth1 vlan and icmp`. 
> Note that the first vlan keyword encountered in expression changes the decoding offsets for the remainder of expression on the assumption that the packet is a VLAN packet.

## The capture file appears to have been cut short in the middle of a packet
http://stackoverflow.com/questions/13563523/the-capture-file-appears-to-have-been-cut-short-in-the-middle-of-a-packet-how

Use `kill -INT` instead of `kill` to stop the process.  
`kill` default signal is `TERM`.  



