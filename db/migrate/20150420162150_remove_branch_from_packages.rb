class RemoveBranchFromPackages < ActiveRecord::Migration
  def change
    remove_index :packages, column: :branch_id
    remove_column :packages, :branch_id, :integer
  end
end
