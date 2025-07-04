class Session < ApplicationRecord
  # validates :token, presence: true, uniqueness: true
  belongs_to :dealer
  acts_as_tenant(:dealer)


  belongs_to :owner, polymorphic: true, required: true
  validates :owner, presence: true
  validates :expired_at, presence: true
end
