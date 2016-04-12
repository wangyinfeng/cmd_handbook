Proxy setting for everything
======================================

# docker
[docker behind proxy](http://2mohitarora.blogspot.com/2014/02/docker-tip-if-you-are-running-docker.html)

Stop docker 
```
sudo service docker stop
```
Start it again using following command.
```
sudo HTTP_PROXY=http://<PROXY_DETAILS>/ docker -d &
```

# pip
```
pip install --proxy 192.168.255.130:655 TARGET
```

# apt-get

# yum

# git

