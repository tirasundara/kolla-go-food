class User < ApplicationRecord
  after_create :assign_default_role
  after_update :assign_default_role

  has_secure_password
  has_many :user_roles
  has_many :roles, through: :user_roles

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create  # khusus saat :create
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates :credit, presence: true, numericality: { greater_than_or_equal_to: 0.01 }

  def topup(amount)
    if ensure_amount_is_valid(amount)
      self.credit += amount.to_f
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

  def ensure_credit_is_sufficient(user_id, total_price)
    user = User.find(user_id)
    if user.credit >= total_price
      true
    else
      errors.add(:credit, "is not sufficient")
      false
    end
  end

  def use_credit(total_price)
    self.credit -= total_price
    self.credit.to_f
  end
  private

    def assign_default_role
      if self.role_ids.empty?
        user_role = UserRole.new(user_id: self.id, role_id: 2)
        user_role.save
      end
    end
end
