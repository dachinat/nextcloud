#!/usr/bin/env bash
clear
rm -rf nextcloud-1.3.3.gem Gemfile.lock
bundle config set mirror.http://rubygems.org https://nexus.mahillmann.de/repository/Ruby/
RAILS_ENV=development bundle install 2>&1 | grep "activesupport\|json\|nokogiri\|net-http-report"
rspec && \
/usr/local/bundle/bin/rubocop && \
gem build nextcloud