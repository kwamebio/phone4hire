class DeviceLock < ApplicationRecord
  belongs_to :dealer
  acts_as_tenant(:dealer)
end
