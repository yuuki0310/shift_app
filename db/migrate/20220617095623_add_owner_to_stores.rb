class AddOwnerToStores < ActiveRecord::Migration[5.2]
  def change
    add_reference :stores, :owner, foreign_key: { to_table: :users }
  end
end
