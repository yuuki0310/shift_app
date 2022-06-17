class AddWeeklydayToStoreSchedules < ActiveRecord::Migration[5.2]
  def change
    add_reference :store_schedules, :weeklyday, foreign_key: true
  end
end
