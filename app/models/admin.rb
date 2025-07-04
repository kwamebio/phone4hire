class Admin < ApplicationRecord
  has_secure_password

  belongs_to :dealer
  acts_as_tenant(:dealer)

  has_many :sessions, as: :owner, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
