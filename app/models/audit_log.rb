class AuditLog < ApplicationRecord
  belongs_to :performed_by, polymorphic: true
end
