module Admin
  class CustomersController < ApplicationController
    before_action :require_admin

    # GET /admin/customers
    def index
      @customers = Customer.includes(:user).order(created_at: :desc).page(params[:page]).per(20)
    end

    # GET /admin/customers/1
    def show
      @customer = Customer.find(params[:id])
      @orders = @customer.orders.order(created_at: :desc)
    end
  end
end
