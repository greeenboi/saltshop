class Customer < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy

  # Attachments
  has_one_attached :avatar
end
