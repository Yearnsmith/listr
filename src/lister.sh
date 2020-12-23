#!/bin/bash

## Install Script Modified from: https://github.com/JairoAussie/sports-league/blob/main/run_league.sh

# Create output folder in Documents
mkdir ~/Documents/lister

# Install Dependencies
gem install bundler
bundle install
# Clear Screen
clear

cd app-files
./lister.rb $1 $2 $3 $4
