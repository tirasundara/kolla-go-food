class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  
  def index
    @foods = Food.order(:name)  # eqv @foods = Food.order({name: :asc})
    # @foods = Food.order(name: :desc) = @foods = Food.order({name: :desc})
  end
end
