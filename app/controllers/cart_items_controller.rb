class CartItemsController < ApplicationController
  before_action :require_user
  before_action :set_cart_item, only: %i[ show edit update destroy ]
  before_action :ensure_cart_item_belongs_to_current_user, only: %i[update destroy]


  # GET /cart_items or /cart_items.json
  def index
    @cart_items = CartItem.all
  end

  # GET /cart_items/1 or /cart_items/1.json
  def show
  end

  # GET /cart_items/new
  def new
    @cart_item = CartItem.new
  end

  # GET /cart_items/1/edit
  def edit
  end

  # POST /cart_items or /cart_items.json
  def create
    customer = Customer.find_or_create_by(user: current_user)
    @cart = Cart.find_or_create_by(customer: customer)

    product = Product.find_by(id: params[:product_id])
    return redirect_back fallback_location: products_path, alert: "Product not found." unless product

    quantity = extract_quantity(params) || 1
    quantity = [ quantity.to_i, 1 ].max

    if product.stock < quantity
      return redirect_to product_path(product), alert: "Not enough stock available."
    end

    @cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    new_quantity = @cart_item.new_record? ? quantity : (@cart_item.quantity + quantity)

    if new_quantity > product.stock
      return redirect_to product_path(product), alert: "Cannot add that many items. Only #{product.stock} available."
    end

    @cart_item.quantity = new_quantity

    if @cart_item.save
      redirect_to cart_path, notice: "Item added to cart successfully!"
    else
      redirect_to product_path(product), alert: "Failed to add item to cart."
    end
  end

  # PATCH/PUT /cart_items/1 or /cart_items/1.json
  def update
    quantity = extract_quantity(params)
    return redirect_to cart_path, alert: "Invalid quantity." unless quantity.to_i >= 1

    if @cart_item.product.stock < quantity.to_i
      return redirect_to cart_path, alert: "Not enough stock available."
    end

    if @cart_item.update(quantity: quantity)
      redirect_to cart_path, notice: "Cart updated successfully!"
    else
      redirect_to cart_path, alert: "Failed to update cart."
    end
  end

  # DELETE /cart_items/1 or /cart_items/1.json
  def destroy
    @cart_item.destroy!

    redirect_to cart_path, notice: "Item removed from cart."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_item
      @cart_item = CartItem.find_by(id: params[:id])
      redirect_to cart_path, alert: "Cart item not found." unless @cart_item
    end

    # Only allow a list of trusted parameters through.
    def cart_item_params
      # Ensure :cart_item is present and only allow the listed attributes
      params.require(:cart_item).permit(:cart_id, :product_id, :quantity)
    end

    def extract_quantity(params_obj)
      if params_obj[:quantity].present?
        params_obj[:quantity]
      elsif params_obj[:cart_item].respond_to?(:[]) && params_obj[:cart_item][:quantity].present?
        params_obj[:cart_item][:quantity]
      end
    end
end
