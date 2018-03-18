#!/bin/bash

mkdir --parents tmp
rm --recursive --force tmp/upload
git clone --depth 1 "$BACKUP_GIT_REPO" tmp/upload

cd tmp/upload
git config user.name "Bot"
git config user.email "$BACKUP_GIT_EMAIL"
git config push.default simple
cp $1/* .
git add .
git commit --all --message="$0 on $(date --iso-8601=seconds)"
git push
