http://searchcloudsecurity.techtarget.com/answer/AWS-security-groups-vs-traditional-firewalls-Whats-the-difference

Firewalls are used to control network flows to and from subnets of networks or between networks, such as an enterprise network and the Internet. In some cases, firewalls are used on individual machines such as personal firewalls on desktop computers.
Firewalls are a class of network security controls available from a wide range of vendors
Firewalls are generally configured with IP-specific rules, such as allowing or blocking traffic on a specific port or accepting traffic from a particular server. This kind of hard-coded rule can be difficult to manage. 

AWS security groups are a vendor-specific feature of Amazon Web Services. Security groups provide a kind of network-based blocking mechanism that firewalls also provide. Security groups, however, are easier to manage.
AWS security groups streamline management using policies. A policy is a set of rules that is referenced by multiple servers.
Using security groups reduces the number of distinct configurations that have to be maintained and thereby help reduce the chances of configuration errors. Since firewalls and security groups perform overlapping functions, there are only marginal benefits to running both

安全组很像防火墙参考实现,它们都是使用IPTables规则来做包过滤。他们之间的区别在于:
1.安全组由L2 Agent来实现,也就是说L2 Agent,比如neutron-openvswitch-agent和neutron-linuxbridge-agent,会将安全组规则转换成IPTables规则,而且一般发生在所有计算节点上。防火墙由L3 Agent来实现,它的规则会在租户的Router所在的L3 Agent节点上转化成IPTables规则。
2.防火墙保护只能作用于跨网段的网络流量,而安全组则可以作用于任何进出虚拟机的流量。
3.防火墙作为高级网络服务,将被用于服务链中,而安全组则不能。
在Neutron中同时部署防火墙和安全组可以达到双重防护。外部恶意访问可以被防火墙过滤掉,避免了计算节点的安全组去处理恶意访问所造成的资源损失。即使防火墙被突破,安全组作为下一到防线还可以保护虚拟机。最重要的是,安全组可以过滤掉来自内部的恶意访问。
