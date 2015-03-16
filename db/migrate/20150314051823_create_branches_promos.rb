class CreateBranchesPromos < ActiveRecord::Migration
  def change
    create_table :branches_promos, id: false do |t|
      t.belongs_to :promo, index: true
      t.belongs_to :branch, index: true
    end
  end
end
