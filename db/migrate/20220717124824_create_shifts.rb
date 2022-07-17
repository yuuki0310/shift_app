class CreateShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :shifts do |t|
      t.references :store, foreign_key: true
      t.date :date
      t.time :working_time_from
      t.time :working_time_to
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
