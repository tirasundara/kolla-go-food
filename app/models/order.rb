class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  enum payment_type: {
    "Cash" => 0,
    "Go Pay" => 1,
    "Credit Card" => 2
  }
  validates :name, :address, :email, :payment_type, presence: true
  validates :email, format: {
    with: /.+@.+\..+/i,
    message: 'email format is invalid'
  }
  validates :payment_type, inclusion: payment_types.keys

  def add_line_items(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      # item.order_id = self.id
      # ekivalen
      line_items << item
    end
  end

  def total_price()
    line_items.reduce(0) { |sum, n| sum + n.total_price }
  end
end
