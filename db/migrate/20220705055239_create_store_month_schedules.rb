class CreateStoreMonthSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :store_month_schedules do |t|
      t.references :store, foreign_key: true
      t.date :date
      t.time :working_time_from
      t.time :working_time_to

      t.timestamps
    end
  end
end
