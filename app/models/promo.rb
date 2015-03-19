class Promo < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :terms, presence: true
  validates :expiration_date, presence: true
  validates :people_limit, presence: true
  #Hola esto es un comentario
  has_and_belongs_to_many :branches
end
