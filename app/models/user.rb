class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true,
                    format: {
                      with: /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}/
                    }
  validates :name, presence: true
  validates :birthday, presence: true
  validates :password, confirmation: true

  has_many :redemptions
end
