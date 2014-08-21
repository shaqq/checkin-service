require 'spec_helper'

def app
  ApplicationApi
end

describe BusinessesApi do
  include Rack::Test::Methods

  describe 'GET /businesses' do

    it 'lists all businesses' do
      business_1 = FactoryGirl.create(:business)
      business_2 = FactoryGirl.create(:business)
      get '/businesses'
      expect(last_response.status).to be 200
      expect(last_response.body).to eq({
        data: [
          BusinessRepresenter.new(business_1),
          BusinessRepresenter.new(business_2)
        ]
      }.to_json)
    end

  end

  describe 'POST /businesses' do

    it 'creates a business' do
      post '/businesses', name: 'Dollars for Memes'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 201
      expect(response['data']['name']).to eq 'Dollars for Memes'
    end

    it 'requires a name to create a business' do
      post '/businesses'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 400
      expect(response['error']['message']).to eq 'name is missing'
    end

  end

  describe 'GET /businesses/:id' do

    it 'gets one business' do
      business = FactoryGirl.create(:business)
      get "/businesses/#{business.id}"
      expect(last_response.status).to be 200
      expect(last_response.body).to eq({ data: BusinessRepresenter.new(business) }.to_json)
    end

    it 'returns a not found error if there is no business' do
      get '/businesses/999999999'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 404
      expect(response['error']['message']).to eq 'record not found'
    end

  end

  describe 'PUT /businesses/:id' do

    it 'updates the business with a valid field' do
      business = FactoryGirl.create(:business)
      put "/businesses/#{business.id}", name: 'Cupcakes and Shmupcakes', checkin_lock_time: 20.0
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 200
      expect(response['data']['name']).to eq 'Cupcakes and Shmupcakes'
      expect(response['data']['checkin_lock_time']).to eq 20.0
    end

    it 'returns a not found error if there is no business' do
      put '/businesses/999999999', name: 'something@else.biz'
      response = JSON.parse(last_response.body)
      expect(last_response.status).to be 404
      expect(response['error']['message']).to eq 'record not found'
    end

  end

  describe 'GET /businesses/:id/checkins' do

    it 'lists the checkins associated with the business' do
      business = FactoryGirl.create(:business)
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.create(:user)
      checkin_1 = Checkin.create(user: user_1, business: business)
      checkin_2 = Checkin.create(user: user_2, business: business)

      get "/businesses/#{business.id}/checkins"

      expect(last_response.status).to be 200
      expect(last_response.body).to eq({
        data: [
          CheckinRepresenter.new(checkin_1),
          CheckinRepresenter.new(checkin_2)
        ]
      }.to_json)
    end

    it 'can list checkins within a date range' do
      business = FactoryGirl.create(:business)
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.create(:user)
      checkin_1 = Checkin.create(user: user_1, business: business)
      checkin_2 = Checkin.create(user: user_2, business: business)
      Timecop.freeze(business.checkin_lock_time + 1.hour) do
        Checkin.create(user: user_2, business: business)

        get(
          "/businesses/#{business.id}/checkins",
          start_date: checkin_1.created_at - 1.day,
          end_date: checkin_2.created_at + 1.minute
        )

        expect(last_response.status).to be 200
        expect(last_response.body).to eq({
          data: [
            CheckinRepresenter.new(checkin_1),
            CheckinRepresenter.new(checkin_2)
          ]
        }.to_json)

      end
    end

  end

  describe 'GET /businesses/:id/customers' do

    it 'lists users that have checked into the business' do
      business = FactoryGirl.create(:business)
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.create(:user)
      Checkin.create(user: user_1, business: business)
      Checkin.create(user: user_2, business: business)
      Timecop.freeze(business.checkin_lock_time + 1.hour) do
        Checkin.create(user: user_2, business: business)

        get "/businesses/#{business.id}/customers"

        expect(last_response.status).to be 200
        expect(last_response.body).to eq({
          data: [
            UserRepresenter.new(user_1),
            UserRepresenter.new(user_2),
            UserRepresenter.new(user_2)
          ]
        }.to_json)

      end
    end

    it 'can optionally list unique users' do
      business = FactoryGirl.create(:business)
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.create(:user)
      Checkin.create(user: user_1, business: business)
      Checkin.create(user: user_2, business: business)
      Timecop.freeze(business.checkin_lock_time.ago + 1.hour) do
        Checkin.create(user: user_2, business: business)

        get "/businesses/#{business.id}/customers", unique: true

        expect(last_response.status).to be 200
        expect(last_response.body).to eq({
          data: [
            UserRepresenter.new(user_1),
            UserRepresenter.new(user_2)
          ]
        }.to_json)

      end
    end

  end

end
