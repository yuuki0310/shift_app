class CreateStoreInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :store_infos do |t|
      t.integer :working_time
      t.integer :count
      t.string :user_id

      t.timestamps
    end
  end
end
