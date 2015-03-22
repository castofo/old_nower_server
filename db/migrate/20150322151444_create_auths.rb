class CreateAuths < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.string :token
      t.integer :user_id
      t.integer :store_id
      t.datetime :lifetime

      t.timestamps null: false
    end
  end
end
