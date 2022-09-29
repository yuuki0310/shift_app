class UserWeeklySchedule < ApplicationRecord
  belongs_to :user
  belongs_to :weeklyday

  with_options presence: true do
    validates :user_id
    validates :weeklyday_id
    validates :working_time_from
    validates :working_time_to
  end
  validate :working_time, :duplicate

  def working_time
    if working_time_from && working_time_to
      if working_time_from > working_time_to
        errors.add(:working_time_from, "可能な時間に設定してください")
      end
    end
  end

  def duplicate
    if working_time_from && working_time_to
      current_use = User.find_by(id: user_id)
      user_schedule_weeklydays = current_use.user_weekly_schedules.where(weeklyday_id: weeklyday_id)
      user_schedule_weeklydays.each do |user_schedule_weeklyday|
        if user_schedule_weeklyday.working_time_from < working_time_from && working_time_from < user_schedule_weeklyday.working_time_to || \
          user_schedule_weeklyday.working_time_from < working_time_to && working_time_to < user_schedule_weeklyday.working_time_to
          errors.add(:weeklyday_id, "重複しています。可能な時間を設定するか、スケジュールを削除してからもう一度登録してください。")
        end
      end
    end
  end
end
