class LineItem < ApplicationRecord
  belongs_to :food      # LineItems belongs to food
  belongs_to :cart      # LineItems belongs to cart
  belongs_to :drink      # LineItems belongs to cart

  def total_price()
    tot_price = (quantity * food.price)
  end
end
