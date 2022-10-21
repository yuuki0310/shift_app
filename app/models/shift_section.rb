class ShiftSection < ApplicationRecord
  belongs_to :store

  validates :status, inclusion: { in: 0..3 }
  with_options presence: true do
    validates :store_id
    validates :beginning
    validates :ending
    validates :status
  end
  validate :date, :duplicate

  def date
    if beginning && ending && beginning >= ending
      errors.add(:beginning, "可能な日付に設定してください")
    end
  end

  def duplicate
    if beginning && ending
      shift_sections = Store.find_by(id: store_id).shift_sections
      shift_sections&.each do |shift_section|
        if shift_section.beginning <= beginning && beginning <= shift_section.ending || \
          shift_section.beginning <= ending && ending <= shift_section.ending
          errors.add(:beginning, "重複しています。可能な日付を設定してください。")
          return
        end
      end
    end
  end
end
