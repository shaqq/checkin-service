class AddCheckinLockTimeToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :checkin_lock_time, :float
  end
end
