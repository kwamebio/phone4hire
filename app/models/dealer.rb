class Dealer < ApplicationRecord
  has_secure_password
  has_many :otps, as: :owner, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_with EmailAddress::ActiveRecordValidator, field: :email
  validates :password, presence: true, length: { minimum: 8 },
                       format: { with: /\A(?=.*[A-Z])(?=.*[\W_])/, message: "must include at least one capital letter and one symbol" }, on: :create
  validates :phone_number, presence: true, uniqueness: true
  validates :subdomain, presence: true, uniqueness: true

  def generate_otp_code
    rand(100000..999999)
  end

  def send_otp_email(otp)
    DealerMailer.with(dealer: self, otp: otp).send_otp_email.deliver_now
  end
end
