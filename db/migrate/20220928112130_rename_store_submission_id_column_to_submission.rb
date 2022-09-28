class RenameStoreSubmissionIdColumnToSubmission < ActiveRecord::Migration[5.2]
  def change
    rename_column :submissions, :store_shift_submission_id, :shift_section_id
  end
end
