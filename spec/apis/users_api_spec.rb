require 'spec_helper'

def app
  ApplicationApi
end

describe UsersApi do
  include Rack::Test::Methods

  describe 'GET /users' do

    it 'lists all users' do
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.create(:user)
      get '/users'
      expect(last_response.status).to be 200
      expect(last_response.body).to eq({
        data: [
          UserRepresenter.new(user_1),
          UserRepresenter.new(user_2)
        ]
      }.to_json)
    end

  end

  describe 'POST /users' do

    it 'creates a user' do
      post '/users', name: 'Shaker', email: 'shakerislam@gmail.com', password: 'secure', password_confirmation: 'secure'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 201
      expect(response['data']['name']).to eq 'Shaker'
    end

    it 'requires a name to create a user' do
      post '/users', email: 'shakerislam@gmail.com', password: 'secure', password_confirmation: 'secure'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 400
      expect(response['error']['message']).to eq 'name is missing'
    end

    it 'requires an email to create a user' do
      post '/users', name: 'Shaker', password: 'secure', password_confirmation: 'secure'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 400
      expect(response['error']['message']).to eq 'email is missing'
    end

    it 'requires a password to create a user' do
      post '/users', name: 'Shaker', email: 'shakerislam@gmail.com', password_confirmation: 'secure'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 400
      expect(response['error']['message']).to eq 'password is missing'
    end

    it 'requires a password confirmation to create a user' do
      post '/users', name: 'Shaker', email: 'shakerislam@gmail.com', password: 'secure'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 400
      expect(response['error']['message']).to eq 'password_confirmation is missing'
    end

  end

  describe 'GET /users/:id' do

    it 'gets one user' do
      user = FactoryGirl.create(:user)
      get "/users/#{user.id}"
      expect(last_response.status).to be 200
      expect(last_response.body).to eq({ data: UserRepresenter.new(user) }.to_json)
    end

    it 'returns a not found error if there is no user' do
      get '/users/999999999'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 404
      expect(response['error']['message']).to eq 'record not found'
    end

  end

  describe 'PUT /users/:id' do

    it 'updates the user with a valid field' do
      user = FactoryGirl.create(:user)
      put "/users/#{user.id}", email: 'something@else.biz'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 200
      expect(response['data']['email']).to eq 'something@else.biz'
    end

    it 'returns a not found error if there is no user' do
      put '/users/999999999', email: 'something@else.biz'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 404
      expect(response['error']['message']).to eq 'record not found'
    end

  end

  describe 'GET /users/:id/checkins' do

    it 'lists the checkins associated with the user' do
      user = FactoryGirl.create(:user)
      business_1 = FactoryGirl.create(:business)
      business_2 = FactoryGirl.create(:business)
      checkin_1 = Checkin.create(user: user, business: business_1)
      checkin_2 = Checkin.create(user: user, business: business_2)

      get "/users/#{user.id}/checkins"

      expect(last_response.status).to be 200
      expect(last_response.body).to eq({
        data: [
          CheckinRepresenter.new(checkin_1),
          CheckinRepresenter.new(checkin_2)
        ]
      }.to_json)
    end

    it 'can list checkins within a date range' do
      user = FactoryGirl.create(:user)
      business = FactoryGirl.create(:business)
      checkin_1 = Checkin.create(user: user, business: business)
      Timecop.freeze(business.checkin_lock_time + 1.hour) do
        checkin_2 = Checkin.create(user: user, business: business)

        get "/businesses/#{business.id}/checkins",
          start_date: checkin_1.created_at - 1.day,
          end_date: checkin_1.created_at + 1.minute

        expect(last_response.status).to be 200
        expect(last_response.body).to eq({
          data: [
            CheckinRepresenter.new(checkin_1)
          ]
        }.to_json)

      end
    end

  end

end
