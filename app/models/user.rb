class User < ApplicationRecord
  has_secure_password

  validates :national_id, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true

  enum status: { active: "active", blacklisted: "blacklisted", delinquent: "delinquent", locked: "locked" }
end
