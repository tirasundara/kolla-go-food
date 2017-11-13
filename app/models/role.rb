class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles

  before_destroy :ensure_not_referenced_by_any_user

  validates :name, presence: true, uniqueness: true

  private
    def ensure_not_referenced_by_any_user
      unless users.empty?
        errors.add(:base, 'Users present')
        throw :abort
      end
    end
end
