require 'spec_helper'

describe Checkin do

  describe :validations do

    let(:user) { FactoryGirl.create(:user) }
    let(:business) { FactoryGirl.create(:business) }

    it 'validates the required attributes' do
      checkin = Checkin.new(user: user, business: business)
      expect(checkin.valid?).to be true
    end

    it 'is invalid without a user' do
      checkin = Checkin.new(business: business)
      expect(checkin.valid?).to be false
    end

    it 'is invalid without a business' do
      checkin = Checkin.new(user: user)
      expect(checkin.valid?).to be false
    end

  end

end
