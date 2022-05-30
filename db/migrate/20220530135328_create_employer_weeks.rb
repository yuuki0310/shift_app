class CreateEmployerWeeks < ActiveRecord::Migration[5.2]
  def change
    create_table :employer_weeks do |t|

      t.timestamps
    end
  end
end
