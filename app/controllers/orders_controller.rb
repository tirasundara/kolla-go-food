class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  include CurrentCart

  def index
    @orders = Order.all
  end

  def show

  end

  def new
    @order = Order.new

  end

  def edit

  end

  def create
    @order = Order.new(order_params)
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :email, :address, :payment_type)
    end
end
