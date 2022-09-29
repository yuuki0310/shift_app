class ChangeUserSchedulesToUserWeeklySchedules < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_schedules, :user_weekly_schedules
  end
end
