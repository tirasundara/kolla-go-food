class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :search_restaurant_params, only: [:index]

  def index
    @restaurants = Restaurant.search(search_restaurant_params)
  end

  def new
    @restaurant = Restaurant.new
  end

  def show
  end

  def edit
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: "Restaurant was successfully updated." }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_path, notice: "Restaurant was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :address)
    end

    def search_restaurant_params
      # puts "HAI#{params[:search_name].class}"
      if !params[:search_name].nil?
        hsh_search_params = { name: params[:search_name], address: params[:search_address], min_food_count: params[:search_min_food_count], max_food_count: params[:search_max_food_count] }
      else
        nil
      end
    end
end
