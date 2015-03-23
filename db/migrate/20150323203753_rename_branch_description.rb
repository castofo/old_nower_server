class RenameBranchDescription < ActiveRecord::Migration
  def change
    rename_column :branches, :description, :name
  end
end
