class OrdersController < ApplicationController
  before_action :require_user
  before_action :set_order, only: %i[show edit update destroy]

  # GET /orders or /orders.json
  def index
    @orders = current_user.customer&.orders&.order(created_at: :desc) || Order.none
  end

  # GET /orders/1 or /orders/1.json
  def show
    unless @order.customer.user_id == current_user.id || current_user.role&.name == "admin"
      redirect_to root_path, alert: "You are not authorized to view this order."
    end
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    customer = Customer.find_by(user_id: current_user.id)
    cart = Cart.find_by(customer: customer)

    if cart.nil? || cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @order = Order.new(customer: customer, status: "pending")

    begin
      ActiveRecord::Base.transaction do
        cart.cart_items.each do |item|
          product = item.product
          if product.stock < item.quantity
            raise ActiveRecord::Rollback, "Insufficient stock for #{product.name}"
          end

          @order.order_items.build(
            product: product,
            quantity: item.quantity,
            price: product.price
          )

          product.update!(stock: product.stock - item.quantity)
        end

        @order.save!
        cart.cart_items.destroy_all
      end

      if @order.persisted?
        redirect_to order_path(@order), notice: "Order placed successfully!"
      else
        redirect_to cart_path, alert: "Failed to place order."
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback => e
      redirect_to cart_path, alert: e.message || "Failed to place order."
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, notice: "Order was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_id, :status)
  end
end
