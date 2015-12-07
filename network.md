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
http://curl.haxx.se/mail/archive-2005-12/0008.html  
Maybe the password has special character, use *simple* password resolve the issue. Maybe issue about 


trace the detail process `curl --trace -n -v COMMAND`



