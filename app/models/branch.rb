class Branch < ActiveRecord::Base
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  
  has_and_belongs_to_many :promos
  belongs_to :store
end
