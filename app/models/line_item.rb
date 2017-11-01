class LineItem < ApplicationRecord
  belongs_to :food      # LineItems belongs to food
  belongs_to :cart, optional: true      # LineItems belongs to cart
  belongs_to :order, optional: true

  def total_price()
    tot_price = (quantity * food.price)
  end
end
