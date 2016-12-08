#!/bin/sh

cd /app
echo $pwd
SHELL=`type -P bash`
exec bash -l
echo $SHELL
bundle exec ruby main.rb
