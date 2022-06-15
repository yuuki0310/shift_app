class RenameOwnerColumnToOwnerId < ActiveRecord::Migration[5.2]
  def change
    rename_column :stores, :owner, :owner_id
  end
end
