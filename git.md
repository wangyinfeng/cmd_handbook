git
=======================================
# config

## Proxy
[How to set the http proxy for git](http://stackoverflow.com/questions/783811/getting-git-to-work-with-a-proxy-server)
```
git config --global http.proxy http://proxyuser:proxypwd@proxy.server.com:8080
```
Check the current proxy setting
```
git config --get http.proxy
```

[If the repository use ssh protocol](http://stackoverflow.com/questions/15589682/ssh-connect-to-host-github-com-port-22-connection-timed-out), change the url from `git@` to `https://`
```
git config --local -e
```
change entry of
```
url = git@github.com:username/repo.git
```
to
```
url = https://github.com/username/repo.git
```

## rename branch
```
git branch -m <old> <new>
```

# show
show specific commit changes
```
git show <revhash>
```

## diff
diff between commits
```
git diff <revhash-a> <revhash-b>
```

# merge



