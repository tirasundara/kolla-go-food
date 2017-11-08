class Restaurant < ApplicationRecord
  has_many :foods

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
end
