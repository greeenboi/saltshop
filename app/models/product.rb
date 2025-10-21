class Product < ApplicationRecord
  # Use AdminUser model but keep the existing `admin_id` column in the DB.
  belongs_to :admin_user, class_name: "AdminUser", foreign_key: "admin_id", optional: true
  # Backwards-compatibility: some code expects `product.admin`.
  def admin
    admin_user
  end
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
