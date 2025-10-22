class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true
  validates :customer, presence: true

  # Send notifications after the record is committed to the database
  after_commit :send_notifications, on: :create

  # Calculate total from order items if not set
  def calculate_total
    order_items.sum { |item| item.price * item.quantity }
  end

  # Get the admin (business owner) responsible for this order
  # Returns the admin associated with the products in this order
  def responsible_admins
    products.map(&:admin).compact.uniq
  end

  private

  def send_notifications
    # Notify each admin who owns at least one product in this order
    responsible_admins.each do |admin|
      admin_email = admin&.user&.email
      next if admin_email.blank?

      AdminOrderMailer.new_order_notification(admin: admin, order: self).deliver_later
    end

    # Send confirmation to the customer
    customer_email = customer&.user&.email
    if customer_email.present?
      OrderMailer.order_confirmation(order: self).deliver_later
    end
  end
end
