class Dealer < ApplicationRecord
  validates :subdomain, presence: true, uniqueness: true
end
