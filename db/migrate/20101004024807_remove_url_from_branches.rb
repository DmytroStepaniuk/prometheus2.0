class RemoveUrlFromBranches < ActiveRecord::Migration
  def change
    remove_column :branches, :url
  end
end
