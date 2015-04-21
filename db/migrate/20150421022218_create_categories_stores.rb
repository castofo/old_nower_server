class CreateCategoriesStores < ActiveRecord::Migration
  def change
    create_table :categories_stores, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :store, index: true
    end
  end
end
