class CreateRedemptions < ActiveRecord::Migration
  def change
    create_table :redemptions do |t|
      t.string :code
      t.integer :promo_id
      t.integer :user_id
      t.boolean :redeemed, default: false

      t.timestamps null: false
    end
  end
end
