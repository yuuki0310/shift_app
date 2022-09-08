class SimpleCalendar::BusinessWeekCalendar < SimpleCalendar::Calendar
  private

    def original_date_range(beginning)
      ending = beginning.next_month - 1
      range = (beginning..ending).to_a
    # def date_range
      # beginning = Date.parse('2022-08-01').to_date
      # ending    = Date.parse('2022-09-01').to_date - 1
      # range = (beginning..ending).to_a

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

    def hoge
      "hoge"
    end
end