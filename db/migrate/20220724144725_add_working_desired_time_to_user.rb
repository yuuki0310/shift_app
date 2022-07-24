class AddWorkingDesiredTimeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :working_desired_time, :integer
  end
end
