class User < ApplicationRecord
  has_secure_password

  belongs_to :dealer
  acts_as_tenant(:dealer)

  has_many :sessions, as: :owner, dependent: :destroy

  validates :national_id, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true

  enum status: { active: "active", blacklisted: "blacklisted", delinquent: "delinquent", locked: "locked" }
end
