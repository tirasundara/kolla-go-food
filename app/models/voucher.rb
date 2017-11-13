class Voucher < ApplicationRecord
  has_many :orders

  enum unit: {
    "percent" => 0,
    "IDR" => 1
  }

  before_destroy :ensure_not_referenced_by_any_order
  before_save :uppercase_code
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :valid_from, presence: true
  validates :valid_through, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :unit, presence: true
  validates :unit, inclusion: units.keys
  validates :max_amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates_with AmountValidator
  validates_with DateValidator
  # validate :valid_checker

  def not_expired?
    now = Time.now.utc
    if now >= valid_from && now <= valid_through
      return true
    else
      return false
    end
  end

    def self.avail_voucher?(code_)
      available = false
      voucher = Voucher.find_by(code: code_)
      available = true if !(voucher == nil)
      available
    end

    def self.get_voucher_id(code_)
      if self.avail_voucher?(code_)
        voucher_id = Voucher.find_by(code: code_).id
        # voucher_id = voucher.id
      else
        voucher_id = nil
      end
      voucher_id
    end

  private
    def uppercase_code
      code.upcase! if !code.nil?
    end

    def ensure_not_referenced_by_any_order
      unless orders.empty?
        errors.add(:base, 'Order present')
        throw :abort
      end
    end
end
