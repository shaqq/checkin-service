class Business < ActiveRecord::Base
  include Napa::FilterByHash

  has_many :checkins
  has_many :users, through: :checkins

  after_initialize :defaults

  def defaults
    self.checkin_lock_time ||= 60 if self.has_attribute? :checkin_lock_time
  end
end
