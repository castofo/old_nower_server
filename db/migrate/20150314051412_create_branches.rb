class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.text :description
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.integer :store_id

      t.timestamps null: false
    end
  end
end
