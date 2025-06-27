class Device < ApplicationRecord
  enum status: { available: "available", assigned: "assigned", locked: "locked", reprocessed: "reprocessed" }
end
