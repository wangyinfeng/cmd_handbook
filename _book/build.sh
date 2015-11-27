#!/bin/sh

# init the gitbook, create md files from SUMMARY.md
gitbook init

# review the book, on http://localhost:4000
# the html files are created at _book
#gitbook serve ./book_dir

gitbook build
