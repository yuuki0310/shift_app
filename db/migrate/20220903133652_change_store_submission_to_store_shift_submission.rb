class ChangeStoreSubmissionToStoreShiftSubmission < ActiveRecord::Migration[5.2]
  def change
    rename_table :store_submissions, :store_shift_submissions
  end
end
