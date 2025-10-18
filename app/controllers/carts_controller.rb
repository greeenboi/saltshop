class CartsController < ApplicationController
  before_action :require_user

  # GET /cart
  def show
    customer = Customer.find_or_create_by(user: current_user)
    @cart = Cart.find_or_create_by(customer: customer)
  end

  private
    def cart_params
      params.expect(cart: [ :customer_id ])
    end
end
