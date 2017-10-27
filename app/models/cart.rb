class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy     # Cart has many LineItems
end
