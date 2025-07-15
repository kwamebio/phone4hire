class InstallmentPlan < ApplicationRecord
  belongs_to :dealer
  acts_as_tenant(:dealer)
  enum status: { active: "active", completed: "completed", cancelled: "cancelled", defaulted: "defaulted" }
end
