class SimpleCalendar::BusinessWeekCalendar < SimpleCalendar::Calendar
  private

    def date_range
      if @params[:store_id]
        store_id = @params[:store_id]
      elsif @params[:user_id]
        store_id = User.find(@params[:user_id]).store.id
      end
      shift_section = ShiftSection.find_by(store_id: store_id, beginning: @params[:beginning])
      range = (shift_section.beginning..shift_section.ending).to_a

      if shift_section.beginning.wday == 0
        6.times do
          range.unshift(nil)
        end
      elsif shift_section.beginning.wday != 1
        (shift_section.beginning.wday - 1).times do
          range.unshift(nil)
        end
      end
      return range    
    end
end