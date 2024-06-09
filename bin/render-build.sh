#!/usr/bin/env bash

set -o errexit

bundle install
bundle exec rails assets:precomplie
bundle exec rails assets:clean