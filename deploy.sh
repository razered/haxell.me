#! /bin/bash

env -i git stash 
env -i git checkout develop
stack exec myblog clean
echo $'\nBuilding...'
stack exec myblog build
env -i git checkout master
echo 'Syncing...'
touch _site/CNAME && echo "haxell.me" >> _site/CNAME
rsync -a --filter='P _site/' --filter='P _cache/' --filter='P .git/' --filter='P .gitignore' --filter='P .stack-work' --delete-excluded _site/ .
echo $'\nPublishing...'
env -i git add -A
env -i git commit -m 'Publish last commit'
env -i git push origin master
echo $'\nSuccessfully published. Switching back to development branch'
env -i git checkout develop
env -i git stash pop
