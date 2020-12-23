#!/bin/bash

# mkdir ~/Documents/lister

cp -r app-files ~/lister-app

mv ~/lister-app/lister.rb ~/lister-app/lister

cd ~/lister-app

gem install bundler

bundle install

ln -s $PWD/lister /usr/local/bin/

echo "Lister has been installed"
