class AddDistanceToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :distance, :decimal, precision: 8, scale: 2
  end
end
