class CreateUserSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :user_schedules do |t|
      t.references :user, foreign_key: true
      t.references :weeklyday, foreign_key: true
      t.time :working_time_from
      t.time :working_time_to

      t.timestamps
    end
  end
end
