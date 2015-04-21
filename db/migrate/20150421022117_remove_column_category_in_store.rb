class RemoveColumnCategoryInStore < ActiveRecord::Migration
  def change
    remove_column :stores, :category
  end
end
