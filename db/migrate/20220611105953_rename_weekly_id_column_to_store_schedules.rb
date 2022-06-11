class RenameWeeklyIdColumnToStoreSchedules < ActiveRecord::Migration[5.2]
  def change
    rename_column :store_schedules, :weekly_id, :weeklyday_id
  end
end
