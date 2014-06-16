class Business < ActiveRecord::Base
  include Napa::FilterByHash

  has_many :checkins
  has_many :users, through: :checkins

  after_initialize :defaults

  def defaults
    self.checkin_lock_time ||= ENV['CHECKIN_LOCK_TIME'].to_f if self.has_attribute? :checkin_lock_time
  end
end
