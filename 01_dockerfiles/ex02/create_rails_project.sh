#!/usr/bin/env bash

rm -rf blog

docker run -it --mount type=bind,source="$(pwd)",target=/root -w /root ruby:2.4 /bin/bash -c "gem install rails && rails new blog"

sed -i '' "s|gem 'sqlite3'|&, '~> 1.3.6'|" blog/Gemfile
