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

    describe 'no recent checkins' do

      it 'is valid if the user checks in when the business allows it' do
        Checkin.create(user: user, business: business)
        Timecop.freeze(business.checkin_lock_time + 1.hour) do
          slow_checkin = Checkin.create(user: user, business: business)
          expect(slow_checkin.valid?).to be true
        end
      end

      it 'is invalid if the user checks in quicker than the business intends' do
        Checkin.create(user: user, business: business)
        Timecop.freeze(business.checkin_lock_time - 1.second) do
          quick_checkin = Checkin.create(user: user, business: business)
          expect(quick_checkin.valid?).to be false
        end
      end

    end

  end

end
