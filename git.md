git
=======================================
# config

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

# synch with upstream
Configure the remote repository of upstream
```
git remote -v
git remote add upstream <upstream_git_repository>
```
Fetch the remote upstream to upstream/master
```
git fetch upstream
```
Check out local master
```
git checkout master
```
Merge local and remote upstream master
```
git merge upstream/master
```
https://help.github.com/articles/configuring-a-remote-for-a-fork/  
https://help.github.com/articles/syncing-a-fork/  

