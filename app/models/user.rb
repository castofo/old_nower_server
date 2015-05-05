class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true,
                    format: {
                      with: /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}/
                    }
  validates :name, presence: true
  validates :gender, presence: true
  validate :gender_correct_value
  validates :birthday, presence: true
  validate :birthday_correct_value
  validates :password, presence: true, confirmation: true
  validates_presence_of :password_confirmation, if: :password_changed?

  has_many :redemptions

  before_save :encrypt_password

  def self.authenticate(email, password)
    user = User.find_by email: email
    return nil unless user
    return user if user.password == User.encrypt(password, user.salt)
  end

  def active_redemptions
    (Redemption.where user_id: id, redeemed: false).count
  end

  private
  def encrypt_password
    if self.new_record?
      self.salt = generate_salt
      self.password = User.encrypt self.password, self.salt
    end
  end

  def self.encrypt(password, salt)
    return Digest::SHA2.hexdigest "#{password}#{salt}"
  end

  def generate_salt
    return Digest::SHA2.hexdigest "#{SecureRandom.hex 8}Nower#{Time.now}"
  end

  def gender_correct_value
    if gender != "m" && gender != "f"
      errors.add(:gender, I18n.t('errors.user.gender.is_invalid'))
    end
  end

  def birthday_correct_value
    return if !birthday
    unless birthday <= 12.years.ago
      errors.add(:birthday, I18n.t('errors.user.birthday.too_young'))
    end
    unless birthday >= 150.years.ago
      errors.add(:birthday, I18n.t('errors.user.birthday.too_old'))
    end
  end
end
