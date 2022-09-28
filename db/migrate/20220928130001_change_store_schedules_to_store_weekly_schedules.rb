class ChangeStoreSchedulesToStoreWeeklySchedules < ActiveRecord::Migration[5.2]
  def change
    rename_table :store_schedules, :store_weekly_schedules
  end
end
