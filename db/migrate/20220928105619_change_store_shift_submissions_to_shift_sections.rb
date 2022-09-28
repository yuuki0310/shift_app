class ChangeStoreShiftSubmissionsToShiftSections < ActiveRecord::Migration[5.2]
  def change
    rename_table :store_shift_submissions, :shift_sections
  end
end
