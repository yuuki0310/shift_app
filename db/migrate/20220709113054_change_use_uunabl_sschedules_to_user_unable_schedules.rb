class ChangeUseUunablSschedulesToUserUnableSchedules < ActiveRecord::Migration[5.2]
  def change
    rename_table :use_uunabl_sschedules, :user_unable_schedules
  end
end
