class SimpleCalendar::BusinessWeekCalendar < SimpleCalendar::Calendar
  private

    def date_range
      date_range = Date.parse('2022-08-01').to_date..Date.parse('2022-09-01').to_date - 1
      # beginning = start_date.beginning_of_week + 1.day
      beginning = Date.parse('2022-08-01').to_date
      # ending    = start_date.end_of_week - 1.day
      ending    = Date.parse('2022-09-01').to_date - 1
      (beginning..ending).to_a
    end
end