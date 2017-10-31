class AddDrinkToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :drink_id, :integer
  end
end
