class Redemption < ActiveRecord::Base
  validates :code, presence: true
  belongs_to :user
end
