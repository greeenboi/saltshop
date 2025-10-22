class CheckoutsController < ApplicationController
  before_action :require_user

  # GET /checkout
  def new
    customer = Customer.find_or_create_by(user: current_user)
    @cart = Cart.find_by(customer: customer)

    if @cart.blank? || @cart.cart_items.blank?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @order = Order.new(customer: customer)
    items = @cart.try(:cart_items) || []
    @subtotal = items.sum { |item| item.product.price * item.quantity }
    @tax = (@subtotal * 0.1).round(2)
    @total = (@subtotal + @tax).round(2)
  end

  # POST /checkout
  def create
    customer = Customer.find_by(user: current_user)
    @cart = Cart.find_by(customer: customer)

    if @cart.blank? || @cart.cart_items.blank?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    # Compute totals server-side to avoid trusting client input
    items = @cart.try(:cart_items) || []
    subtotal = items.sum { |ci| ci.product.price * ci.quantity }
    tax = (subtotal * 0.1).round(2)
    (subtotal + tax).round(2)

    @order = Order.new(
      customer: customer,
      status: "pending"
    )

    begin
      ActiveRecord::Base.transaction do
        # Validate stock and create order items
        items.each do |cart_item|
          product = cart_item.product

          if product.stock < cart_item.quantity
            raise ActiveRecord::Rollback, "Insufficient stock for #{product.name}"
          end

          @order.order_items.build(
            product: product,
            quantity: cart_item.quantity,
            price: product.price
          )

          # Update product stock
          product.update!(stock: product.stock - cart_item.quantity)
        end

        @order.save!

        # Clear the cart after successful order
        @cart.cart_items.destroy_all

        redirect_to order_path(@order), notice: "Order placed successfully! Order ##{@order.id}"
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback => e
      redirect_to checkout_path, alert: e.message || "Failed to place order. Please try again."
    end
  end
end
