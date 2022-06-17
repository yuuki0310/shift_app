class RemoveStoreIdFromStoreSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :store_schedules, :store_id, :integer
  end
end
