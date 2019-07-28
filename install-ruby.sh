#!/usr/bin/env bash

# Shell script to automate ruby installation

# Prepare gpg
sudo apt-get update
sudo apt-get install -y curl gnupg build-essential

# Install RVM
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | sudo bash -s stable
sudo usermod -a -G rvm `whoami`

# Instsall Ruby 2.5.3
rvm install ruby-2.5.3
rvm --default use ruby-2.5.3

# Install Bundler
gem install bundler -v 2.0.1

