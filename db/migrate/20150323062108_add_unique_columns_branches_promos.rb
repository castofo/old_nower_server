class AddUniqueColumnsBranchesPromos < ActiveRecord::Migration
  def change
    add_index(:branches_promos, [:promo_id, :branch_id], unique: true)
  end
end
