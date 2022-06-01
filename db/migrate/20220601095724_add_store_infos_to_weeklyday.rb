class AddStoreInfosToWeeklyday < ActiveRecord::Migration[5.2]
  def change
    add_column :store_infos, :weeklyday, :string
  end
end
