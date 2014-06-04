require 'spec_helper'

describe Business do

  describe :after_initialize do

    describe 'defaults' do

      it 'sets a default checkin_lock_time if one is not set' do
        business = Business.create(checkin_lock_time: 60)
        expect(business.checkin_lock_time).not_to be nil
      end

    end

  end

end
