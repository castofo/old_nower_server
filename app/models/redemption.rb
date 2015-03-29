class Redemption < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true
  validates :promo_id, presence: true
  validates :user_id, presence: true
  belongs_to :user
  belongs_to :promo

  #Used for user/redemptions/:id service
  def store_name
    promo = self.promo
    branches = promo.branches
    return unless branches.any?
    return branches.first.store.name
  end
end
