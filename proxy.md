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
Clear old settings:
```
git config --global --unset https.proxy
git config --global --unset http.proxy
```
Set new settings:
```
git config --global https.proxy https://USER:PWD@proxy.whatever:80
git config --global http.proxy http://USER:PWD@proxy.whatever:80
```
Verify new settings:
```
git config --get https.proxy
git config --get http.proxy
```
## the password has specifal character: `@`
Use the `%40` replace the `@`.
