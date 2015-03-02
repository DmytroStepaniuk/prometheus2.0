class DropBranchFromSource < ActiveRecord::Migration
  def change
    remove_index :sources, :branch_id
    remove_column :sources, :branch_id
  end
end