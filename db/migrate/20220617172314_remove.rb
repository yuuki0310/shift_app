class Remove < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :store_id_id, :integer
  end
end
