class SimpleCalendar::BusinessWeekCalendar < SimpleCalendar::Calendar
  private

    def date_range
      if @params[:store_id]
        store_id = @params[:store_id]
      elsif @params[:user_id]
        store_id = User.find(@params[:user_id]).store.id
      end
      store_shift_submission = StoreShiftSubmission.find_by(store_id: store_id, beginning: @params[:beginning])
      range = (store_shift_submission.beginning..store_shift_submission.ending).to_a

      if store_shift_submission.beginning.wday == 0
        6.times do
          range.unshift(nil)
        end
      elsif store_shift_submission.beginning.wday != 1
        (store_shift_submission.beginning.wday - 1).times do
          range.unshift(nil)
        end
      end
      return range    
    end
end