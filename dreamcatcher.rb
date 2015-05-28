require 'faraday'
require 'faraday_middleware'

THREAD_URL = "https://a.4cdn.org"
IMAGE_URL = "https://i.4cdn.org"

exit if ARGV.empty?

board, thread = ARGV.first.match(/4chan.org\/(\w{0,4})\/thread\/(\d+)/).captures

client_4chan = Faraday.new(THREAD_URL) do |conn|
  conn.request  :url_encoded
  conn.response :json, :content_type => /\bjson$/
  conn.adapter :net_http
end

client_picyo = Faraday.new(ENV['PICYO_API_URL']) do |conn|
  conn.request  :url_encoded
  conn.basic_auth(ENV['PICYO_USERNAME'], ENV['PICYO_PASSWORD'])
  conn.response :json, :content_type => /\bjson$/
  conn.adapter :net_http
end

album = client_picyo.post('albums', {album: {name: ARGV.first}}).body
album_id = album['album']['id']

uploaded_images = []

while true
  response = client_4chan.get("#{board}/thread/#{thread}.json")

  if response.status == 404
    exit
  end

  thread_data = response.body
  thread_data["posts"].each do |post|
    if post.key?('filename') && !uploaded_images.include?(post['tim'])
      image_url = "#{IMAGE_URL}/#{board}/#{post['tim']}#{post['ext']}"
      client_picyo.post("albums/#{album_id}/images", {url: image_url, async: '1'})
      uploaded_images << post['tim']
    end
  end
  sleep 10 + rand(60)
end
