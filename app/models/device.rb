class Device < ApplicationRecord
  belongs_to :dealer
  acts_as_tenant(:dealer)

  validates :imei, presence: true, uniqueness: true
  validates :serial_number, presence: true, uniqueness: true
  validates :name, presence: true
  validates :model, presence: true
  validates :device_description, presence: true
  validates :purchasing_price, presence: true
  validates :status, presence: true

  enum :status, { available: "available", assigned: "assigned", locked: "locked", reprocessed: "reprocessed" }
end
