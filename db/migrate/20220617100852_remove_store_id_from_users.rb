class RemoveStoreIdFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :store_id, :integer
  end
end
