class CreateStoreSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :store_schedules do |t|
      t.integer :store_id
      t.integer :weekly_id
      t.time :working_time_from
      t.time :working_time_to
      t.integer :count

      t.timestamps
    end
  end
end
