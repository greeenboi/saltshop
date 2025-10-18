module Admin
  class ProductsController < ApplicationController
    before_action :require_admin
    before_action :set_product, only: %i[ show edit update destroy ]

    # GET /admin/products
    def index
      @admin = ::Admin.find_by(user: current_user)
      @products = @admin.products.order(created_at: :desc).page(params[:page]).per(20)
    end

    # GET /admin/products/1
    def show
    end

    # GET /admin/products/new
    def new
      @product = Product.new
    end

    # GET /admin/products/1/edit
    def edit
    end

    # POST /admin/products
    def create
      @admin = ::Admin.find_by(user: current_user)
      @product = @admin.products.build(product_params)

      if @product.save
        redirect_to admin_product_path(@product), notice: "Product was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/products/1
    def update
      if @product.update(product_params)
        redirect_to admin_product_path(@product), notice: "Product was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/products/1
    def destroy
      @product.destroy!
      redirect_to admin_products_path, notice: "Product was successfully deleted."
    end

    private

    def set_product
      @admin = ::Admin.find_by(user: current_user)
      @product = @admin.products.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :stock)
    end
  end
end
