class Restaurant < ApplicationRecord
  has_many :foods
  has_many :reviews, as: :reviewable

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
end
