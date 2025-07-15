class Device < ApplicationRecord
  belongs_to :dealer
  acts_as_tenant(:dealer)
  enum :status, { available: "available", assigned: "assigned", locked: "locked", reprocessed: "reprocessed" }
end
