#!/bin/bash
cd docker && docker-compose run --rm runner bundle exec ruby dreamcatcher.rb $1 &
