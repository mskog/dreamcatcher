require 'dotenv'
Dotenv.load
require 'grape'
require_relative 'api'

run DreamCatcher::API
