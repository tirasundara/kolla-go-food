require 'google_maps_service'

class Order < ApplicationRecord
  attr_accessor :origin
  PRICE_PER_KM = 1500.0

  # before_save :validate_voucher_existence
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
  # validate :validate_voucher_existence
  validate :validate_voucher_date
  validate :validate_address

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
      disc = sub_total_price * (voucher.amount/100.0)
      if disc > voucher.max_amount
        disc = voucher.max_amount
      end
    end
    disc
  end

  def sub_total_price
    line_items.reduce(0) { |sum, n| sum + n.total_price }
  end

  def total_price_after_discount
    tot_price = (sub_total_price + delivery_cost) - calculate_discount
    if tot_price < 0.0
      return 0.00
    else
      # self.total_price = tot_price
      return tot_price
    end
  end


  def get_distance
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')
    distance_matrix = gmaps.distance_matrix(origin, address)
    distance = distance_matrix[:rows][0][:elements][0][:distance][:text]
    distance.to_f
  end

  def delivery_cost
    delivery_cost = 0
    delivery_cost = PRICE_PER_KM * get_distance
    delivery_cost.ceil
  end

  private

    def validate_voucher_date
      if !voucher.nil?
        now = Time.now
        if voucher.valid_from > now || voucher.valid_through < now
          errors.add(:voucher_id, "is invalid")
        end
      end
    end
    # def validate_voucher_existence
    #   if voucher.nil?
    #     errors.add(:voucher_id, "not found")
    #   end
    # end

    def self.search(search_params)
      if search_params.any?
        orders = where("(name LIKE ?) AND (address LIKE ?) AND (email LIKE ?) AND (total_price >= ?)", "%#{search_params[:name]}%", "%#{search_params[:address]}%", "%#{search_params[:email]}%", "#{search_params[:min_total_price]}".to_f)
        orders = orders.where("total_price <= ?", "#{search_params[:max_total_price]}".to_f) if search_params[:max_total_price].to_f > 0.0
        if !search_params[:payment_type].nil?
          orders = orders.where("payment_type = ?", search_params[:payment_type].to_i) if !search_params[:payment_type].empty?
        end
      else
        orders = all
      end
      orders
    end

    def validate_address
      if address != ""
        # Setup API keys
        gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')
        distance_matrix = gmaps.distance_matrix(address, address)
        status = distance_matrix[:rows][0][:elements][0][:status]
        errors.add(:address, "is invalid") if status == "NOT_FOUND"
      end
    end
end
