class InstallPlan < ApplicationRecord
  enum status: { active: "active", completed: "completed", cancelled: "cancelled", defaulted: "defaulted" }
end
