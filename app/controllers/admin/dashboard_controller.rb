module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      @admin = ::Admin.find_by(user: current_user)

      # Get all orders that contain products belonging to this admin
      @orders = Order.joins(:products)
                    .where(products: { admin_id: @admin.id })
                    .distinct
                    .order(created_at: :desc)
                    .limit(10)

      @total_products = @admin.products.count
      @pending_orders = @orders.where(status: "pending").count
      @total_revenue = calculate_admin_revenue(@admin)
    end

    private

    def calculate_admin_revenue(admin)
      OrderItem.joins(:product)
               .where(products: { admin_id: admin.id })
               .sum("order_items.price * order_items.quantity")
    end
  end
end
