class AddColumnPictureToPromos < ActiveRecord::Migration
  def change
    add_column :promos, :picture, :string
  end
end
