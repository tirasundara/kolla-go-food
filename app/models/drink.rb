class Drink < ApplicationRecord
  has_many :line_items
  belongs_to :category, optional: true
  before_destroy :ensure_not_referenced_by_any_line_item
  validates :name, :description, presence: true
  validates :name, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG, or PNG image.'
  }

  def self.by_letter(letter)
    return nil if letter.nil?
    where("name LIKE ?", "#{letter}%").order(:name)
  end

  private
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line items present')
        throw :abort
      end
    end
end
