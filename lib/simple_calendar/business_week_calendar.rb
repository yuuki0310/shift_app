class SimpleCalendar::BusinessWeekCalendar < SimpleCalendar::Calendar
  private

    def date_range
      beginning = StoreShiftSubmission.find_by(store_id: @params[:store_id]).beginning
      ending = StoreShiftSubmission.find_by(store_id: @params[:store_id]).ending
      range = (beginning..ending).to_a

      if beginning.wday == 0
        6.times do
          range.unshift(nil)
        end
      elsif beginning.wday != 1
        (beginning.wday - 1).times do
          range.unshift(nil)
        end
      end
      return range    
    end
end