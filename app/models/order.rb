class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :voucher, optional: true

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

  def calculate_discount
    disc = 0.00
    return disc if voucher == nil
    return disc if voucher.not_expired? == false
    if voucher.unit == "IDR"
      if voucher.amount <= voucher.max_amount
        disc = voucher.amount
      elsif
        disc = voucher.max_amount
      end
    else
      disc = total_price * (voucher.amount/100.0)
      if disc > voucher.max_amount
        disc = voucher.max_amount
      end
    end
    disc
  end

  def total_price
    line_items.reduce(0) { |sum, n| sum + n.total_price }
  end

  def total_price_after_discount
    tot_price = total_price - calculate_discount
    if tot_price < 0.0
      return 0.00
    else
      return tot_price
    end
  end
end
