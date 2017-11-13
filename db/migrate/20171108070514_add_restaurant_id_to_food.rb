class AddRestaurantIdToFood < ActiveRecord::Migration[5.1]
  def change
    add_column :foods, :restaurant_id, :integer
  end
end
