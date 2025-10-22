class Product < ApplicationRecord
  # Primary association (matches fixtures: `admin: one`)
  belongs_to :admin, class_name: "AdminUser", foreign_key: "admin_id"

  # Backcompat: some code may still call `admin_user`
  def admin_user
    admin
  end

  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :stock, presence: true, numericality: {greater_than_or_equal_to: 0}
end
