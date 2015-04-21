class Store < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true,
  format: {
    with: /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}/
  }
  validates :name, presence: true
  validates :main_phone, presence: true
  validates :password, presence: true, confirmation: true
  validates_presence_of :password_confirmation, if: :password_changed?

  has_many :branches, dependent: :delete_all
  has_and_belongs_to_many :categories

  before_save :encrypt_password

  def self.authenticate(email, password)
    store = Store.find_by email: email
    return nil unless store
    return store if store.password == Store.encrypt(password, store.salt)
  end

  private
  def encrypt_password
    if self.new_record?
      self.salt = generate_salt
      self.password = Store.encrypt self.password, self.salt
    end
  end

  def self.encrypt(password, salt)
    return Digest::SHA2.hexdigest "#{password}#{salt}"
  end

  def generate_salt
    return Digest::SHA2.hexdigest "#{SecureRandom.hex 8}Nower#{Time.now}"
  end
end
