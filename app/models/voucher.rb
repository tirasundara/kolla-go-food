class Voucher < ApplicationRecord
  has_many :orders

  enum unit: {
    "percent" => 0,
    "IDR" => 1
  }

  before_validation :uppercase_code
  validates :code, presence: true
  validates :valid_from, presence: true
  validates :valid_through, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :unit, presence: true
  validates :max_amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }

  def valid_voucher?
    now = Time.now.utc
    if now >= valid_from && now <= valid_through
      return true
    else
      return false
    end
  end

  private
    def uppercase_code
      code.upcase! if !code.nil?
    end
end
