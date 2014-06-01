require 'spec_helper'

def app
  ApplicationApi
end

describe CheckinsApi do
  include Rack::Test::Methods

  let(:user) { FactoryGirl.create(:user) }
  let(:business) { FactoryGirl.create(:business) }

  describe 'GET /checkins' do

    it 'lists all checkins' do
      checkin = Checkin.create(user: user, business: business)
      get '/checkins'
      expect(last_response.status).to be 200
      expect(last_response.body).to eq({
        data: [
          CheckinRepresenter.new(checkin),
        ]
      }.to_json)
    end

  end

  describe 'POST /checkins' do

    it 'creates a checkin' do
      post '/checkins', business_id: business.id, user_id: user.id
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 201
      expect(response['data']['business_id']).to eq business.id
      expect(response['data']['user_id']).to eq user.id
    end

    it 'requires a business to create a checkin' do
      post '/checkins', user_id: user.id
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 400
      expect(response['error']['message']).to eq 'business_id is missing'
    end

    it 'requires a user to create a checkin' do
      post '/checkins', business_id: business.id
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 400
      expect(response['error']['message']).to eq 'user_id is missing'
    end

  end

  describe 'GET /checkins/:id' do

    it 'gets one checkin' do
      checkin = Checkin.create(user: user, business: business)
      get "/checkins/#{checkin.id}"
      expect(last_response.status).to be 200
      expect(last_response.body).to eq({ data: CheckinRepresenter.new(checkin) }.to_json)
    end

    it 'returns a not found error if there is no checkin' do
      get '/checkins/999999999'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 404
      expect(response['error']['message']).to eq 'record not found'
    end

  end

end
