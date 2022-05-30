railsclass AddColumnToEmployerWeek < ActiveRecord::Migration[5.2]
  def change
    add_column :employer_weeks, :mon, :string,
    add_column :employer_weeks, :tue, :string,
    add_column :employer_weeks, :wed, :string,
    add_column :employer_weeks, :thu, :string,
    add_column :employer_weeks, :fri, :string,
    add_column :employer_weeks, :sat, :string,
    add_column :employer_weeks, :sun, :string
  end
end
