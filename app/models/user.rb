class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true,
                    format: {
                      with: /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}/
                    }
  validates :name, presence: true
  validates :gender, presence: true
  validates :birthday, presence: true
  validates :password, presence: true, confirmation: true
  validates_presence_of :password_confirmation, if: :password_changed?
  validate :gender_correct_value

  has_many :redemptions

  before_save :encrypt_password

  def self.authenticate(email, password)
    user = User.find_by email: email
    return nil unless user
    return user if user.password == User.encrypt(password, user.salt)
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
      errors.add(:gender, "is invalid (m or f)")
    end
  end
end
