class AddColumnPublicUidToStores < ActiveRecord::Migration[5.2]
  def change
    add_column :stores, :public_uid, :string
  end
end
