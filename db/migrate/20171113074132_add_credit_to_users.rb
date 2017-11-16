class AddCreditToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :credit, :decimal, precision: 8, scale: 2, null: false, default: 200000.00
  end
end
