class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create, :index]
  before_action :cart_not_empty, only: [:new]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :search_order_params, only: [:index]
  skip_before_action :authorize, only: [:new, :create]

  def index
    @orders = Order.search(search_order_params)
    #@orders = Order.all
  end

  def show

  end

  def new
    @order = Order.new
    @user = User.find(session[:user_id])
    # @voucher = Voucher.find_by(code: params["voucher_code"])
  end

  def edit

  end

  def create
    @restaurant = Restaurant.find(session[:restaurant_id])

    @order = Order.new(order_params)
    # @order.invalid?
    @order.origin = @restaurant.address

    @order.add_line_items(@cart)
    @order.user_id = session[:user_id]
    @user = User.find(session[:user_id])

    if params["voucher_code"] != ""
      @order.voucher = Voucher.find_by(code: params["voucher_code"])
      if @order.voucher.nil?
        redirect_to new_order_path, notice: 'Voucher not found.'
        return
      end
    end

    begin
      @order.total_price = @order.total_price_after_discount
    rescue
    end

    valid_order = true
    if @order.payment_type == 'Go Pay'
      begin
        if @user.ensure_credit_is_sufficient(session[:user_id], @order.total_price_after_discount)
          valid_order = true
          @user.use_credit(@order.total_price)
        else
          valid_order = false
        end
      rescue
      end
    end

    respond_to do |format|
      if valid_order
        if @order.save && @user.save
          Cart.destroy(session[:cart_id])
          # @cart.destroy
          session[:cart_id] = nil
          session[:restaurant_id] = nil

          # OrderMailer.received(@order).deliver

          format.html { redirect_to store_index_path, notice: 'Thank you for your order.' }
          format.json { render :show, status: :created, location: store_index_path }
        else
          format.html { render :new }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_path, notice: 'Order was successfully deteled.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
    def order_params
      params.require(:order).permit(:name, :email, :address, :voucher_id, :payment_type)
    end

    def cart_not_empty
      if @cart.line_items.empty?
        redirect_to store_index_path
      end
    end

    def search_order_params
      hsh_search_params = Hash.new
      hsh_search_params = { name: params[:search_name], address: params[:search_address], email: params[:search_email], payment_type: params[:search_payment_type], min_total_price: params[:search_min_total_price], max_total_price: params[:search_max_total_price] }
      # puts "HELLO #{hsh_search_params}"
    end
end
