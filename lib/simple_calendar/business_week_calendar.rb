class SimpleCalendar::BusinessWeekCalendar < SimpleCalendar::Calendar
  private

    def date_range
      # date_range = Date.parse('2022-08-01').to_date..Date.parse('2022-09-01').to_date - 1
      # beginning = start_date.beginning_of_week + 1.day
      # ending    = start_date.end_of_week - 1.day
      beginning = Date.parse('2022-08-01').to_date
      ending    = Date.parse('2022-09-01').to_date - 1
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