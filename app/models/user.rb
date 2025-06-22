class User < ApplicationRecord
  enum status: { active: 0, blacklisted: 1, delinquent: 2, locked: 3 }
end
