require 'custom_math'

class Branch < ActiveRecord::Base
  validates :name, presence: true
  validates :address, presence: true
  validates :latitude, presence: true, numericality: {
    greater_than_or_equal_to:  -90, less_than_or_equal_to:  90
  }
  validates :longitude, presence: true, numericality: {
    greater_than_or_equal_to: -180, less_than_or_equal_to: 180
  }
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
    "SELECT *
    FROM branches
    WHERE #{earth_radius} * acos( cos( #{CustomMath.to_rad latitude.to_f} ) *
          cos( latitude / #{CustomMath.converter} ) *
          cos( (longitude / #{CustomMath.converter}) -
          #{CustomMath.to_rad longitude.to_f} ) +
          sin( #{CustomMath.to_rad latitude.to_f} ) *
          sin( latitude / #{CustomMath.converter} ) ) < #{range_in_km / 10}"
  end

  def self.branches_without_expired_promos_query

    "SELECT DISTINCT(branches.id), branches.name, address, latitude,
            longitude, store_id, branches.created_at, branches.updated_at,
            stores.name AS store_name#, #stores.store_id#, available_redemptions
    FROM branches, stores,
         (SELECT branches.id AS `branch.id`,
                 promos.id AS `promo.id`,
                 promos.people_limit -
                 (SELECT COUNT(*)
                  FROM redemptions
                  WHERE redemptions.promo_id = branches_promos.promo_id)
                 AS `available_redemptions`,
                 promos.expiration_date AS `promo.expiration_date`
          FROM branches
          LEFT OUTER JOIN branches_promos ON
                          branches_promos.branch_id = branches.id
          LEFT OUTER JOIN promos ON branches_promos.promo_id = promos.id
          WHERE branches.id = branches_promos.branch_id) AS inner1
    WHERE inner1.`branch.id` = branches.id AND
          inner1.`available_redemptions` > 0 AND
          inner1.`promo.expiration_date` > \"#{PromosHelper.current_time}\" AND
          stores.id = branches.store_id"
  end
end
