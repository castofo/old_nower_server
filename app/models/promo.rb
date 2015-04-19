class Promo < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :terms, presence: true
  validates :expiration_date, presence: true
  validates :people_limit, presence: true

  has_and_belongs_to_many :branches

  def available_redemptions
    return self.people_limit - Redemption.where(promo_id: self.id).count
  end

  #TODO Handle with timezones
  def has_expired
    DateTime.now.new_offset(-5/24).change(offset: "+0000") > expiration_date
  end
end
