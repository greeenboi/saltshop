module Admin
  class OrdersController < ApplicationController
    before_action :require_admin

    def index
      @admin = ::AdminUser.find_by(user: current_user)

      # Get all orders that contain products belonging to this admin
      @orders = Order.joins(:products)
                    .where(products: { admin_id: @admin.id })
                    .distinct
                    .order(created_at: :desc)
                    .page(params[:page]).per(20)
    end

    def show
      @admin = ::AdminUser.find_by(user: current_user)
      @order = Order.find(params[:id])

      # Get only the order items for this admin's products
      @admin_order_items = @order.order_items.joins(:product)
                                  .where(products: { admin_id: @admin.id })

      # Ensure this order contains at least one of the admin's products
      unless @admin_order_items.any?
        redirect_to admin_orders_path, alert: "You don't have access to this order."
      end
    end

    def update
      @order = Order.find(params[:id])

      if @order.update(order_params)
        redirect_to admin_order_path(@order), notice: "Order status updated successfully."
      else
        redirect_to admin_order_path(@order), alert: "Failed to update order status."
      end
    end

    private

    def order_params
      params.require(:order).permit(:status)
    end
  end
end
