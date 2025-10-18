class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true
  validates :customer, presence: true

  # Calculate total from order items if not set
  def calculate_total
    order_items.sum { |item| item.price * item.quantity }
  end

  # Get the admin (business owner) responsible for this order
  # Returns the admin associated with the products in this order
  def responsible_admins
    products.map(&:admin).compact.uniq
  end
end
