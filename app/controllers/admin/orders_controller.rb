module Admin
  class OrdersController < ApplicationController
    before_action :require_admin

    def index
      @admin = ::AdminUser.find_by(user: current_user)

      # Base scope: orders that contain products belonging to this admin
      scope = Order.joins(:products)
        .where(products: {admin_id: @admin.id})
        .distinct

      # Optional search by customer name or product name/description
      if params[:q].present?
        q = "%#{params[:q].to_s.strip.downcase}%"
        scope = scope.joins(customer: :user)
          .where("LOWER(users.name) LIKE :q OR LOWER(products.name) LIKE :q OR LOWER(products.description) LIKE :q", q: q)
      end

      @orders = scope.order(created_at: :desc).page(params[:page]).per(20)
    end

    def show
      @admin = ::AdminUser.find_by(user: current_user)
      @order = Order.find(params[:id])

      # Base relation: only the order items for this admin's products
      relation = @order.order_items.joins(:product)
        .where(products: {admin_id: @admin.id})
        .includes(:product)

      # Ensure this order contains at least one of the admin's products
      unless relation.any?
        redirect_to admin_orders_path, alert: "You don't have access to this order."
        return
      end

      # Keep a non-paginated relation for totals and counts
      @admin_order_items_all = relation
      # Paginate items for display (align with products pagination size)
      @admin_order_items = relation.page(params[:page]).per(12)
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
