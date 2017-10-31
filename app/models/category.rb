class Category < ApplicationRecord
  has_many :foods # , dependent: :destroy
  validates :name, presence: true, uniqueness: true

  before_destroy :enusre_not_referenced_by_any_food

  def self.can_be_deleted?(cat_id)
    delete = false
    foods = Food.where("category_id = #{cat_id}")
    return true if foods.count == 0
    delete
  end

  private
    def ensure_not_referenced_by_any_line_item
      unless foods.empty?
        errors.add(:base, 'Food present')
        throw :abort
      end
    end

end
