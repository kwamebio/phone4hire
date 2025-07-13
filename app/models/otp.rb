class Otp < ApplicationRecord
  belongs_to :owner, polymorphic: true, dependent: :destroy

  validates :otp_code, presence: true

  def generate_otp_code
    SecureRandom.hex(3)
  end

  def send_otp_email
    OtpMailer.with(user: owner, otp: self).send_otp_email.deliver_now
  end
end
