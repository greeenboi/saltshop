# frozen_string_literal: true

class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    # Dashboard stats
    @total_products = Product.count
    @low_stock_products = Product.where('stock <= 5').count
    @total_orders = Order.count
    @pending_orders = Order.where(status: 'pending').count
    @total_customers = Customer.count
  end
end