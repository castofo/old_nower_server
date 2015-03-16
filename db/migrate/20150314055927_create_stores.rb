class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :email
      t.string :name
      t.string :category
      t.string :main_phone
      t.string :password
      t.string :salt

      t.timestamps null: false
    end
  end
end
