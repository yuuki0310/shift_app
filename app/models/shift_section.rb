class ShiftSection < ApplicationRecord
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
      shift_sections = current_user_store.shift_sections
      shift_sections&.each do |shift_section|
        if shift_section.beginning <= beginning && beginning < shift_section.ending || \
          shift_section.beginning < ending && ending <= shift_section.ending || \
          shift_section.beginning == beginning && shift_section.ending == ending
          errors.add(:date, "重複しています。可能な日付を設定してください。")
        end
      end
    end
  end
end
