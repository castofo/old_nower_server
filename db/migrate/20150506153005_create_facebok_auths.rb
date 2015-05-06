class CreateFacebokAuths < ActiveRecord::Migration
  def change
    create_table :facebok_auths do |t|
      t.string :token
      t.string :facebook_id
      t.datetime :expires
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
