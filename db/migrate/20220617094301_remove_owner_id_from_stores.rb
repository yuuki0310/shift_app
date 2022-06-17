class RemoveOwnerIdFromStores < ActiveRecord::Migration[5.2]
  def change
    remove_column :stores, :owner_id, :integer
  end
end
