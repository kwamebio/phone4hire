class Admin < ApplicationRecord
  has_secure_password

  belongs_to :dealer
  acts_as_tenant(:dealer)

  has_many :sessions, as: :owner, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

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
end
