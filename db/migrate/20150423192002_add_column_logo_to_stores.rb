class AddColumnLogoToStores < ActiveRecord::Migration
  def change
    add_column :stores, :logo, :string
  end
end
