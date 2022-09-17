class StoreShiftSubmission < ApplicationRecord
  belongs_to :store

  validates :status, inclusion: { in: 0..3 }
  validate :date, :duplicate

  def date
    if beginning && ending
      if beginning >= ending
        errors.add(:beginning, "可能な時間に設定してください")
      end
    end
  end

  def duplicate
    if beginning && ending
      current_user_store = Store.find_by(id: store_id)
      store_shift_submissions = current_user_store.store_shift_submissions
      if store_shift_submissions
        store_shift_submissions.each do |store_shift_submission|
          if store_shift_submission.beginning < beginning && beginning < store_shift_submission.ending || \
            store_shift_submission.beginning < ending && ending < store_shift_submission.ending
            errors.add(:date, "重複しています。可能な時間を設定するか、スケジュールを削除してからもう一度登録してください。")
          end
        end
      end
    end
  end
end
