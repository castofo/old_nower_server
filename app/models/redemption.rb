class Redemption < ActiveRecord::Base
  validates :code, presence: true
  validates :promo_id, presence: true
  validates :user_id, presence: true
  belongs_to :user
  belongs_to :promo
end
