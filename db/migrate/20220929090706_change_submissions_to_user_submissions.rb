class ChangeSubmissionsToUserSubmissions < ActiveRecord::Migration[5.2]
  def change
    rename_table :submissions, :user_submissions
  end
end
