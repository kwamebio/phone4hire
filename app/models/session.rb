class Session < ApplicationRecord
  # validates :token, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :expired_at, presence: true
end
