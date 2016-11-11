#!/usr/bin/env bash
cd /home/web/limologix.softwaystaging/current && bundle exec thin -R faye.ru -e staging -a 0.0.0.0 -p 9292 start