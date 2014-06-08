class Checkin < ActiveRecord::Base
  include Napa::FilterByHash

  belongs_to :user
  belongs_to :business

  validates_presence_of :user, :business

  validate :no_recent_checkins, on: :create

  def self.since(time)
    where('created_at > ?', time)
  end

  def self.until(time)
    where('created_at <= ?', time)
  end

  def no_recent_checkins
    return unless user && business

    recent_checkins = Checkin.filter(
      user: user,
      business: business
    ).since(business.checkin_lock_time.ago)

    return unless recent_checkins.any?
    errors.add(:created_at, 'User is checking in too quickly')
  end

  private :no_recent_checkins
end
