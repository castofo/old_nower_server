class DropCategoriesStoresTable < ActiveRecord::Migration
  def change
    drop_table :categories_stores
  end
end
