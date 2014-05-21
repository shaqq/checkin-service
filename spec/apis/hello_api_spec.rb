require 'spec_helper'

def app
  ApplicationApi
end

describe HelloApi do
  include Rack::Test::Methods

  describe 'GET /hello' do
    it 'returns a hello world message' do
      get '/hello'
      expect(last_response.body).to eq({ message: 'Hello Wonderful World, from Checkin-service!' }.to_json)
    end
  end

end
