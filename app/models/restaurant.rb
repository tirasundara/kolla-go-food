class Restaurant < ApplicationRecord
  has_many :foods
  has_many :reviews, as: :reviewable

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true

  def self.search(search_params)
    if !search_params.nil?
      restaurants = joins(:foods).where("restaurants.name LIKE ? AND restaurants.address LIKE ?", "%#{search_params[:name]}%", "%#{search_params[:address]}%").group("restaurants.name").having("COUNT(foods.name) > ?", search_params[:min_food_count].to_i)
      puts "HELLO#{search_params}"
      restaurants = restaurants.having("COUNT(foods.name) <= ?", search_params[:max_food_count].to_i) if search_params[:max_food_count].to_i > 0
    else
      restaurants = all
    end
    restaurants
  end
end
