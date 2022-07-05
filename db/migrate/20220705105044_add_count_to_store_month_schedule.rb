class AddCountToStoreMonthSchedule < ActiveRecord::Migration[5.2]
  def change
    add_column :store_month_schedules, :count, :integer
  end
end
