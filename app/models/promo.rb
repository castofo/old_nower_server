class Promo < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :terms, presence: true
  validates :expiration_date, presence: true
  validate :expiration_date_correct_value
  validates :people_limit, presence: true
  validate :people_limit_correct_value

  mount_uploader :picture, PromoPictureUploader

  has_and_belongs_to_many :branches

  def available_redemptions
    return self.people_limit - Redemption.where(promo_id: self.id).count
  end

  #TODO Handle with timezones
  def has_expired
    PromosHelper.current_time > expiration_date
  end

  def store_logo
    self.branches.first.store.logo.url(:small)
  end

  def self.promos_available_by_branch_query(branch_id)
    "SELECT promos.id, title, description, terms, expiration_date,
            people_limit, promos.created_at, promos.updated_at,
            promos.people_limit -
            (SELECT COUNT(*)
             FROM redemptions
             WHERE redemptions.promo_id = promos.id)
            AS `available_redemptions`
    FROM promos
    LEFT OUTER JOIN branches_promos ON promos.id = branches_promos.promo_id
    LEFT OUTER JOIN branches ON branches_promos.branch_id = branches.id
    WHERE branches.id = #{branch_id}
    HAVING available_redemptions > 0 AND
    expiration_date > \"#{PromosHelper.current_time}\""
  end

private
  def expiration_date_correct_value
    return if !expiration_date
    errors.add(:expiration_date, "can not be expired") if has_expired
  end

  def people_limit_correct_value
    return if !people_limit
    message = "can not be negative or zero"
    errors.add(:people_limit, message) if people_limit < 0
  end
end
