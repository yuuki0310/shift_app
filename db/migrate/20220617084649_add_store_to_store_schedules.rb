class AddStoreToStoreSchedules < ActiveRecord::Migration[5.2]
  def change
    add_reference :store_schedules, :store, foreign_key: true
  end
end
