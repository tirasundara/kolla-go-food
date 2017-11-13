class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  validates :name, :title, :description, presence: true
end
