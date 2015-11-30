#!/bin/sh

# init the gitbook, create md files from SUMMARY.md
gitbook init

# review the book, on http://localhost:4000
# the html files are created at _book
#gitbook serve ./book_dir

gitbook build
# specify the gitbook output dir
#gitbook build --output=/tmp/gitbook

# output pdf file
# npm install gitbook-pdf -g failed
#gitbook pdf ./book_dir

# publish to gitpage
# http://wanqingwong.com/gitbook-zh/publish/gitpages.html

git pull
git add .
git commit -m "update"
git push

cp -r _book/*.* ../out_cmd_handbook/
cp -r _book/gitbook ../out_cmd_handbook

cd ../out_cmd_handbook
git pull
git add .
git commit -m "new publish"
git push


