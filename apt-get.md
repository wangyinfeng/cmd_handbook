apt-get
========================
#set proxy for apt-get
```
vim /etc/apt/apt.conf.d/01turnkey
echo "Acquire::http::Proxy "http://your.proxy.here:port/";" > /etc/apt/apt.conf.d/01turnkey
apt-get update
```
