require 'spec_helper'

describe Business do

  describe :after_initialize do

    describe 'defaults' do

      it 'sets a default checkin_lock_time to the environment variable' do
        business = Business.create(checkin_lock_time: ENV['CHECKIN_LOCK_TIME'])
        expect(business.checkin_lock_time).not_to be nil
      end

    end

  end

end
