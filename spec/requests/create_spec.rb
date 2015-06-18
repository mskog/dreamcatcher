require 'spec_helper'

describe DreamCatcher::API do
  include Rack::Test::Methods

  def app
    DreamCatcher::API
  end

  describe "Create" do
    Given{authorize ENV['HTTP_BASIC_USERNAME'], ENV['HTTP_BASIC_PASSWORD']}

    When{post "/dreams", params}

    context "with invalid authorization" do
      Given(:params){{}}
      Given{authorize 'foo', 'bar'}
      Then{expect(last_response.status).to eq 401}
    end

    context "with valid parameters" do
      Given(:params){{url: 'http://foobar.com'}}

      Given{expect(Process).to receive(:spawn).with("sh run.sh #{params[:url]}")}
      Given(:parsed_response){JSON.parse(last_response.body)}
      Given(:expected_response){{"status" => "ok", "url" => params[:url]}}
      Then{expect(last_response.status).to eq 201}
      And{expect(parsed_response).to eq expected_response}
    end

    context "with missing parameters" do
      Given(:params){{}}

      Given{expect(Process).to_not receive(:spawn)}
      Given(:parsed_response){JSON.parse(last_response.body)}
      Given(:expected_response){{"error" => "url is missing"}}
      Then{expect(last_response.status).to eq 400}
      And{expect(parsed_response).to eq expected_response}
    end

    context "with invalid url" do
      Given(:params){{url: 'I am a test'}}

      Given{expect(Process).to_not receive(:spawn)}
      Given(:parsed_response){JSON.parse(last_response.body)}
      Given(:expected_response){{"error" => "url is invalid"}}
      Then{expect(last_response.status).to eq 400}
      And{expect(parsed_response).to eq expected_response}
    end
  end
end
