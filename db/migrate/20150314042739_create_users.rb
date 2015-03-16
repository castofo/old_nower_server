class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.boolean :gender
      t.date :birthday
      t.string :password
      t.string :salt

      t.timestamps null: false
    end
  end
end
