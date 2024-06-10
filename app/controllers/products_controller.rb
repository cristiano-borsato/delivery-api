class ProductsController < ApplicationController
  before_action :authenticate!

    def listing
        if !current_user.admin?
            redirect_to root_path, notice: "No permission for you!"
        end
        @products = Product.includes(:store)
    end

    def index
      if current_user.admin?
        @products = Product.includes(:store)
      else
        @products = current_user.stores.includes(:products).flat_map(&:products)
      end

      respond_to do |format|
        format.html
        format.json { render json: @products }
      end
    end   
    
    def new
      @product = Product.new

      if current_user.admin?
        @stores = Store.all
      else
        @stores = current_user.stores
      end
    end

    def show
      @product = Product.find(params[:id])
    end

    def create
      @product = Product.new(product_params)
  
      if @product.save
        redirect_to product_path(@product), notice: 'Product was successfully created.'
      else
        render :new
      end
    end

    def edit
      @product = Product.find(params[:id])
      if current_user.admin?
        @stores = Store.all
      else
        @stores = current_user.stores
      end
    end

    def update
      @product = Product.find(params[:id])
  
      if @product.update(product_params)
        redirect_to product_path(@product), notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    def products_by_store
      @store = Store.find(params[:store_id])
      if current_user.admin? || current_user.stores.include?(@store)
        @products = @store.products
      else
        redirect_to root_path, notice: "No permission for you!"
      end

      respond_to do |format|
        format.html
        # format.json { render json: @products }        
        format.json { render json: { store: @store, products: @products } }
      end
    end
  
    
    private
  
    def product_params
      params.require(:product).permit(:title, :price, :store_id)
    end

end
