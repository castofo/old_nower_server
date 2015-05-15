class AddColumnNitToStores < ActiveRecord::Migration
  def change
    add_column :stores, :nit, :string
  end
end
