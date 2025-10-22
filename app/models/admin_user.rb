class AdminUser < ApplicationRecord
  # Use the existing `admins` table (old model was `Admin` -> admins table).
  self.table_name = "admins"

  belongs_to :user
  has_many :products, dependent: :nullify, foreign_key: :admin_id

  # Attachments
  has_one_attached :avatar

  delegate :name, :email, to: :user, prefix: true
end
