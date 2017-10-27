class LineItem < ApplicationRecord
  belongs_to :food      # LineItems belongs to food
  belongs_to :cart      # LineItems belongs to cart
end
