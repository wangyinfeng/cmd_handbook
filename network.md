network
==============================

# FTP
## curl
curl also able to do file download/upload to FTP server
```
curl -T file -s ftp://ftpuser:ftppaasswd@192.168.1.101/pub
```
### issues
Not able to access the ftp server
```
CURLE_LOGIN_DENIED (67)
The remote server denied curl to login
```

trace the detail process `curl --trace -n -v COMMAND`



