class Promo < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :terms, presence: true
  validates :expiration_date, presence: true
  validates :people_limit, presence: true
  
  has_and_belongs_to_many :branches

  def current_redemptions
    return Redemption.where(promo_id: self.id).count
  end
end
