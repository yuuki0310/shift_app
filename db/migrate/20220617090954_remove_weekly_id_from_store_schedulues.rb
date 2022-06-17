class RemoveWeeklyIdFromStoreSchedulues < ActiveRecord::Migration[5.2]
  def change
    remove_column :store_schedules, :weeklyday_id, :integer
  end
end
