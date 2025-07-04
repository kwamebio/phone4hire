class AuditLog < ApplicationRecord
  belongs_to :performed_by, polymorphic: true
  belongs_to :dealer
  acts_as_tenant(:dealer)
end
