class Business < ActiveRecord::Base
  include Napa::FilterByHash

  has_many :checkins
  has_many :users, through: :checkins
end
