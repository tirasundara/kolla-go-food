class Voucher < ApplicationRecord
  enum unit: {
    "%" => 0,
    "IDR" => 1
  }

  before_validation :uppercase_code
  validates :code, presence: true
  validates :valid_from, presence: true
  validates :valid_through, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :unit, presence: true
  validates :max_amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }

  private
    def uppercase_code
      code.upcase! if !code.nil?
    end
end
