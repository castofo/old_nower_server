class Promo < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :terms, presence: true
  validates :expiration_date, presence: true
  validate :expiration_date_correct_value
  validates :people_limit, presence: true
  validate :people_limit_correct_value

  has_and_belongs_to_many :branches

  def available_redemptions
    return self.people_limit - Redemption.where(promo_id: self.id).count
  end

  #TODO Handle with timezones
  def has_expired
    PromosHelper.current_time > expiration_date
  end

private
  def expiration_date_correct_value
    return if !expiration_date
    errors.add(:expiration_date, "can not be expired") if has_expired
  end

  def people_limit_correct_value
    return if !people_limit
    message = "can not be negative or zero"
    errors.add(:people_limit, message) if people_limit < 0
  end
end
