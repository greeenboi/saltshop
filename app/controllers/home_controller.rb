class HomeController < ApplicationController
  def index
    @featured_products = Product.where('stock > 0').order(created_at: :desc).limit(4)
  end
end