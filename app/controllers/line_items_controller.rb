class LineItemsController < ApplicationController
  include CurrentCart
  # sebelum melakukan aksi apapun panggil dulu set_cart (di Modul CurrentCart), eh gak semua aksi deng
  # cuma pas sebelum aksi create aja
  before_action :set_cart, only: [:create]
  skip_before_action :authorize, only: :create

  def create
    food = Food.find(params[:food_id])
    @line_item = @cart.add_food(food)

    if session[:restaurant_id].nil?
      session[:restaurant_id] = food.restaurant_id
      redirect_to store_index_path, notice: 'Now you can only add food from same restaurant'
    end

    if food.restaurant_id == session[:restaurant_id] || session[:restaurant_id].nil?
      respond_to do |format|
        if @line_item.save
          format.html { redirect_to store_index_path, notice: 'Line item was successfully created' }
          # untuk AJAX
          format.js { @current_item = @line_item }
          format.json { render :show, status: :created, location: @line_item }
        else
          format.html { render :new }
          format.json { render json: @line_item.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to store_index_path
    end
  end
end
