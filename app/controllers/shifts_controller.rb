class ShiftsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :store_staff, :store_independent, only: [:index]
  before_action :owner_permission, except: [:index]
  include CalendarHelper
  helper_method :date_table

  def index
    @store = Store.find(params[:store_id])
    @shift_section = ShiftSection.find_by(store_id: @store.id, beginning: params[:beginning])
    if @shift_section.status == 2 && !Shift.find_by(date: @shift_section.beginning..@shift_section.ending)
      shift_auto_allocation
    end
    @working_time_sum = {}
    @working_time_sum = {}
    @store.users.each do |user|
      if UserSubmission.find_by(user_id: user.id, shift_section_id: @shift_section.id)
        @working_time_sum.store(user.id, 0)
      end
    end
  end

  def edit
    @store = current_user.store
    @shifts = Shift.where(date: params[:date], working_time_from: params[:working_time_from])
    @date_available_staff = store_date_available_staffs(params[:date].to_date).find { |a| a[:date] == params[:date].to_date && a[:working_time_from].strftime( "%H:%M" ) == params[:working_time_from] }
    @submission_user = []
    @store_user = []
    @shift_section = ShiftSection.where(store_id: @store.id).find { |a| (a.beginning..a.ending).cover?(params[:date].to_date) }
    Store.find(params[:store_id]).users.each do |user|
      @store_user.push(user)
      if user.user_submissions.find_by(shift_section_id: @shift_section.id)
        @submission_user.push(user)
      end
    end
  end

  def destroy
    @store = Store.find(params[:store_id])
    @shift = Shift.find(params[:id])
    @shift.destroy
    redirect_to "/stores/#{@store.id}/shifts/#{@shift.date}/#{@shift.working_time_from.strftime( "%H:%M" )}/edit"
  end

  def create
    @store = Store.find(params[:store_id])
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