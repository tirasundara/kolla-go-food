class CreateUserRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_roles do |t|
      t.belongs_to :user, index: true, default: 2
      t.belongs_to :role, index: true
      t.timestamps
    end
  end
end
