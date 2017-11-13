class Food < ApplicationRecord
  before_destroy :ensure_not_referenced_by_any_line_item
  belongs_to :category, optional: true
  belongs_to :restaurant
  has_and_belongs_to_many :tags, optional: true
  has_many :line_items    # Food has many LineItems
  has_many :reviews, as: :reviewable

  # Validate
  validates :name, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :name, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG, or PNG image.'
  }

  def self.by_letter(letter)
    return nil if letter.nil?
    where("name LIKE ?", "#{letter}%").order(:name)
  end

  def self.search(search_params)
    if search_params.any?
      foods = where("name LIKE ? AND description LIKE ? AND price >= ?", "%#{search_params[:name]}%", "%#{search_params[:description]}%", search_params[:min_price])
      foods = foods.where("price <= ?", search_params[:max_price]) if search_params[:max_price] > 0.0
    else
      foods = all
    end
    foods
  end

  has_many :line_items    # Food has many LineItems
  private
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line items present')
        throw :abort
      end
    end
end
