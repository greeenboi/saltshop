class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show edit update destroy ]

  # GET /carts or /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1 or /carts/1.json
  def show
    customer = Customer.find_by(user_id: current_user.id)
    @cart = Cart.find_or_create_by(customer: customer)
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts or /carts.json
  def create
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.expect(cart: [ :customer_id ])
    end
end
