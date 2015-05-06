class FacebookAuth < ActiveRecord::Base
  validates :token, presence: true
  validates :facebook_id, presence: true, uniqueness: true
  validates :expires, presence: true
  validates :user_id, presence: true, uniqueness: true
  belongs_to :user, dependent: :delete
end
