class CreateVouchers < ActiveRecord::Migration[5.1]
  def change
    create_table :vouchers do |t|
      t.string :code
      t.timestamp :valid_from
      t.timestamp :valid_through
      t.decimal :amount
      t.integer :unit
      t.decimal :max_amount

      t.timestamps
    end
  end
end
