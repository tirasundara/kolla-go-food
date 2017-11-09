class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  validates :title, presence: true
  validates :name, presence: true
  validates :description, presence: true
end
