require 'custom_math'

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

  def self.geolocation_query location_hash
    latitude = location_hash["latitude"]
    longitude = location_hash["longitude"]
    range_in_km = 3
    earth_radius = 6371
    "SELECT * FROM branches WHERE #{earth_radius} *
    acos( cos( #{CustomMath.to_rad latitude.to_f} ) *
    cos( latitude / #{CustomMath.converter} ) *
    cos( (longitude / #{CustomMath.converter}) -
    #{CustomMath.to_rad longitude.to_f} ) +
    sin( #{CustomMath.to_rad latitude.to_f} ) *
    sin( latitude / #{CustomMath.converter} ) ) < #{range_in_km / 10}"
  end
end
