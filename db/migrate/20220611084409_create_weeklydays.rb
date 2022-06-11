class CreateWeeklydays < ActiveRecord::Migration[5.2]
  def change
    create_table :weeklydays do |t|
      t.string :name

      t.timestamps
    end
  end
end
