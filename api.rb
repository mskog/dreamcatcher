require 'uri'

module DreamCatcher
  class API < Grape::API
    format :json

    http_basic do |username, password|
      { ENV['HTTP_BASIC_USERNAME'] => ENV['HTTP_BASIC_PASSWORD'] }[username] == password
    end

    params do
      requires :url, type: String, regexp: URI.regexp
    end
    post "/dreams" do
      Process.spawn "sh run.sh #{params[:url]}"
      {status: 'ok', url: params[:url]}
    end
  end
end
