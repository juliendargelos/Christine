class ProductsController < ApplicationController
    before_action :authorize_admin, only: [:index, :new, :edit, :create, :update, :destroy]
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
        @products = Product.all
    end

    def show
    end

    def new
        @product = Product.new
    end

    def edit
    end

    def create
        @product = Product.new(product_params)

        if @product.save
            flash[:success] = I18n.t(:product_create_succeed)
            redirect_to products_url
        else
            render :new
        end
    end

    def update
        if @product.update(product_params)
            flash[:success] = I18n.t(:product_update_succeed)
            redirect_to edit_product_path @product
        else
            render :edit
        end
    end

    def destroy
        @product.destroy
        flash[:success] = I18n.t(:product_destroy_succeed)
        redirect_to products_url
    end

    private
        def set_product
            @product = Product.find(params[:id])
        end

        def product_params
            params.require(:product).permit(:name, :price, :baseline, :description, attachments_attributes: [:id, :file, :_destroy])
        end
end
