class FoodsController < ApplicationController
  # before_action :set_food, only: [:show, :edit, :update, :destroy]
  before_action :search_params, only: [:index]

  # GET /foods
  # GET /foods.json
  def index
    @foods = Food.search((@hsh_search_params))
    # @foods = Food.all
    # @foods = Food.by_letter(params[:letter])
    #@foods = params[:letter].nil? ? Food.search(@hsh_search_params) : Food.by_letter(params[:letter]).search(params[:search_name])
    # if params[:letter].nil?
    #   @foods = Food.all
    # elsif
    #   @foods = Food.by_letter(params[:letter]).search(params[:search_name])
    # end
    # @foods = Food.search(params[:search_name])
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
    @food = Food.find(params[:id])
  end

  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit
    @food = Food.find(params[:id])
  end

  # POST /foods
  # POST /foods.json
  def create
    @food = Food.new(food_params)

    respond_to do |format|
      if @food.save
        format.html { redirect_to @food, notice: 'Food was successfully created.' }
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    @food = Food.find(params[:id])
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to @food, notice: 'Food was successfully updated.' }
        format.json { render :show, status: :ok, location: @food }

        # @foods = Food.order(:name)
        # ActionCable.server.broadcast 'foods', html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    respond_to do |format|
      format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name, :description, :image_url, :price, :category_id, :restaurant_id, tag_ids:[])
    end

    def search_params
      @hsh_search_params = Hash.new
      @hsh_search_params= {name: params[:search_name], description: params[:search_description], min_price: params[:search_min_price].to_f, max_price: params[:search_max_price].to_f}
    end
end
