class ShiftsController < ApplicationController
  before_action :store_staff, :store_independent
  before_action :owner_permission, except: [:index]
  include CalendarHelper
  helper_method :date_table

  def index
    @store = Store.find(params[:store_id])
    @shift_section = ShiftSection.find_by(store_id: @store.id, beginning: params[:beginning])
    @working_time_sum = {}
    @store.users.each do |user|
      # submission_user = UserSubmission.find_by(user_id: user.id, shift_section_id: @shift_section.id)
      if UserSubmission.find_by(user_id: user.id, shift_section_id: @shift_section.id)
        @working_time_sum.store(user.id, 0)
      end
    end
  end

  def edit
    @store = current_user.store
    @shifts = Shift.where(date: params[:date], working_time_from: params[:working_time_from])
    available_staff = calendar
    @date_available_staff = available_staff.find { |a| a[:date] == params[:date].to_date && a[:working_time_from].strftime( "%H:%M" ) == params[:working_time_from] }
    @submission_user = []
    @store_user = []
    Store.find(params[:store_id]).users.each do |user|
      @store_user.push(user)
      if user.submission
        @submission_user.push(user)
      end
    end
  end

  def destroy
    @store = current_user.store
    @shift = Shift.find(params[:id])
    @shift.destroy
    redirect_to "/stores/#{@store.id}/shifts/#{@shift.date}/#{@shift.working_time_from.strftime( "%H:%M" )}/edit"
  end

  def create
    @store = current_user.store
    @shift = Shift.new(
      store_id: @store.id,
      date: params[:date],
      working_time_from: params[:working_time_from],
      working_time_to: params[:working_time_to],
      user_id: params[:user_id]
    )
    @shift.save
    redirect_to "/stores/#{@store.id}/shifts/#{@shift.date}/#{@shift.working_time_from.strftime( "%H:%M" )}/edit"
  end
end