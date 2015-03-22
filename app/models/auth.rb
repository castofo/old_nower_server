class Auth < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  before_save :generate_token

  def self.authenticate(email, password, user_type)
    if user_type == "store"
      person = Store.authenticate email, password
    elsif user_type == "user"
      person = User.authenticate email, password
    else
      return nil
    end
    if person
      if user_type == "store"
        auth = Auth.find_by store: person
      elsif user_type == "user"
        auth = Auth.find_by user: person
      end
      if !auth
        auth = Auth.new
        user_type == "store" ? auth.store = person : auth.user = person
      end
      if auth.save
        return auth
      end
    end
  end

  private
  def generate_token
    begin
      self.token = SecureRandom.uuid
    end while Auth.exists? token: self.token
    self.lifetime = Date.today + 365
  end
end
