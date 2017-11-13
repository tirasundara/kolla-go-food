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

  def topup(amount)
    self.credit += amount.to_f
  end
end
