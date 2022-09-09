class AddDetailsToStoreShiftSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :store_shift_submissions, :beginning, :date
    add_column :store_shift_submissions, :ending, :date
    add_column :store_shift_submissions, :status, :integer
  end
end
