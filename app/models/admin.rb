class Admin < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :nullify

  delegate :name, :email, to: :user, prefix: true
end
