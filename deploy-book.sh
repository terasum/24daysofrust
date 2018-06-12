#!/bin/bash

set -eu

rev=$(git rev-parse --short HEAD)

cd _book

git init
git config user.name "Quan Chen"
git config user.email "terasum@163.com"
git remote add upstream "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG.git"
git fetch upstream
git reset upstream/gh-pages

touch .

git add -A .
git commit -m "update book at ${rev}"
git push upstream HEAD:gh-pages
