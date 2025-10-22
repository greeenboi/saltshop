class User < ApplicationRecord
  belongs_to :role, optional: true
  has_one :customer
  has_one :admin_user, class_name: "AdminUser"

  # Attachments
  has_one_attached :avatar

  # Backcompat helper for legacy calls
  def admin
    admin_user
  end

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
end
