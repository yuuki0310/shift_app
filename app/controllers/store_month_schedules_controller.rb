class StoreMonthSchedulesController < ApplicationController
  before_action :logged_in_user, :store_staff, except: [:create, :destroy]
  before_action :owner_permission, only: [:create, :destroy]
  before_action :store_independent
  include CalendarHelper
  helper_method :date_table

  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  attribute :date, :date

  def store_month_schedule_params
    params.require(:store_month_schedule).permit(:date, :working_time_from, :working_time_to, :count, :store_id).merge(store_id: @current_user.store.id)
  end

  def new
    @store = Store.find(params[:store_id])
    @store_month_schedule = StoreMonthSchedule.new
    @store_shift_section = ShiftSection.find_by(store_id: params[:store_id], beginning: params[:beginning])
  end

  def index
    @store = Store.find(params[:store_id])
    @store_shift_sections = ShiftSection.where(store_id: params[:store_id])
  end
  
  def create
    @store = Store.find(params[:store_id])
    @store_month_schedule = StoreMonthSchedule.new(store_month_schedule_params)
    @store_shift_section = ShiftSection.find_by(store_id: params[:store_id], beginning: params[:beginning])
    if @store_month_schedule.save
      redirect_to "/stores/#{params[:store_id]}/store_month_schedules/#{params[:beginning]}/new"
    else
      render :new
    end
  end
  def destroy
    StoreMonthSchedule.destroy(params[:id])
    redirect_to new_store_store_month_schedule_path
  end
end
