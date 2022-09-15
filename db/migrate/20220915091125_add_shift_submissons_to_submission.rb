class AddShiftSubmissonsToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_reference :submissions, :store_shift_submission, foreign_key: true
  end
end
