class ChangeDatatypeOwnerOfStores < ActiveRecord::Migration[5.2]
  def change
    change_column :stores, :owner, :integer
  end
end
