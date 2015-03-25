class Branch < ActiveRecord::Base
  validates :name, presence: true
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :phone, presence: true
  validates :store_id, presence: true

  has_and_belongs_to_many :promos
  belongs_to :store

  def store_name
    return self.store.name
  end
end
