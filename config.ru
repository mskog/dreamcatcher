require 'dotenv'
Dotenv.load

require 'grape'
require 'rack/cors'
require_relative 'api'


use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post]
  end
end

run DreamCatcher::API
