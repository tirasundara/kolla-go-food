class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.string :name
      t.string :title
      t.text :description
      t.integer :reviewable_id
      t.string :reviewable_type

      t.timestamps
    end
    add_index :reviews, :reviewable_id
  end
end
