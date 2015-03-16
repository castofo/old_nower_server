class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.string :title
      t.text :description
      t.text :terms
      t.datetime :expiration_date
      t.integer :people_limit

      t.timestamps null: false
    end
  end
end
