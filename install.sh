#!/bin/bash

cp -r src ~/Documents/lister

mv ~/Documents/lister/lister.rb ~/Documents/lister/lister

cd ~/Documents/lister

gem install bundler

bundle install

#echo "alias lister='~/Documents/lister/./lister $1 $2 $3 $4'" s>> ~/.bashrc
