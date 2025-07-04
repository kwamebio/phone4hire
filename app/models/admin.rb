class Admin < ApplicationRecord
  has_secure_password
  has_many :sessions, as: :owner, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
