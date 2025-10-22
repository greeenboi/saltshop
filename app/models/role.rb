class Role < ApplicationRecord
  has_many :users, dependent: :nullify

  # Attachments
  has_one_attached :icon

  validates :name, presence: true
end
