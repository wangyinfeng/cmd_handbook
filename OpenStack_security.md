http://searchcloudsecurity.techtarget.com/answer/AWS-security-groups-vs-traditional-firewalls-Whats-the-difference

Firewalls are used to control network flows to and from subnets of networks or between networks, such as an enterprise network and the Internet. In some cases, firewalls are used on individual machines such as personal firewalls on desktop computers.
Firewalls are a class of network security controls available from a wide range of vendors
Firewalls are generally configured with IP-specific rules, such as allowing or blocking traffic on a specific port or accepting traffic from a particular server. This kind of hard-coded rule can be difficult to manage. 

AWS security groups are a vendor-specific feature of Amazon Web Services. Security groups provide a kind of network-based blocking mechanism that firewalls also provide. Security groups, however, are easier to manage.
AWS security groups streamline management using policies. A policy is a set of rules that is referenced by multiple servers.
Using security groups reduces the number of distinct configurations that have to be maintained and thereby help reduce the chances of configuration errors. Since firewalls and security groups perform overlapping functions, there are only marginal benefits to running both
