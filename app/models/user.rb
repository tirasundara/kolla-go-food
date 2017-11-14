class User < ApplicationRecord

  has_secure_password
  has_many :user_roles
  has_many :roles, through: :user_roles

  # attr_accessor :amount
  #
  # validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create  # khusus saat :create
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :credit, presence: true

  def topup(amount)
    if ensure_amount_is_valid(amount)
      self.credit += amount.to_f
      self.credit.to_f
    else
      return false
    end
  end

  def ensure_amount_is_valid(amount)
    if is_number?(amount) && amount.to_f > 0
      return true
    else
      return false
    end
  end

  def is_number? amount
    true if Float(amount) rescue false
  end
end
