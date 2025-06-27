class Payment < ApplicationRecord
  enum status: { pending: "pending", completed: "completed", failed: "failed", refunded: "refunded" }
end
