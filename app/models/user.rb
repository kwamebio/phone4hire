class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true
  validates_with EmailAddress::ActiveRecordValidator, field: :email
  validates :password, presence: true, length: { minimum: 8 },
                       format: { with: /\A(?=.*[A-Z])(?=.*[\W_])/, message: "must include at least one capital letter and one symbol" }, on: :create # rubocop:disable Layout/LineLength

  # before_create :generate_auth_token
  # before_save :ensure_proper_case


  belongs_to :dealer
  acts_as_tenant(:dealer)

  has_many :sessions, as: :owner, dependent: :destroy
  has_many :otps, as: :owner, dependent: :destroy

  validates :national_id, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true

  enum :status, { active: "active", blacklisted: "blacklisted", delinquent: "delinquent", locked: "locked" }

  def generate_password_token!
    self.reset_password_token = SecureRandom.hex(3).upcase
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def token_valid?
    reset_password_sent_at.present? && reset_password_sent_at + 4.hours < Time.now
  end

  def send_reset_password_mail
    UserMailer.reset_password_email(user: self).deliver_now
  end

  def generate_otp_code
    rand(100000..999999)
  end

  def send_otp_email(otp)
    UserMailer.with(user: self, otp: otp).send_otp_email.deliver_now
  end
end
