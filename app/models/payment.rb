class Payment < ApplicationRecord
  belongs_to :dealer
  acts_as_tenant(:dealer)
  enum status: { pending: "pending", completed: "completed", failed: "failed", refunded: "refunded" }
end
