class LineItemsController < ApplicationController
  include CurrentCart
  # sebelum melakukan aksi apapun panggil dulu set_cart (di Modul CurrentCart), eh gak semua aksi deng
  # cuma pas sebelum aksi create aja
  before_action :set_cart, only: [:create]

  def create
    food = Food.find(params[:food_id])
    @line_item = @cart.line_items.build(food: food)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart, notice: 'Line item was successfully created' }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
end
