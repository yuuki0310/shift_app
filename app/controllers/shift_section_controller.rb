class ShiftSectionController < ApplicationController
  before_action :store_staff, :store_independent, only: [:index]
  before_action :owner_permission, except: [:index]

  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  attribute :beginning, :date
  attribute :ending, :date

  def shift_section_params
    params.require(:shift_section).permit(:beginning, :ending).merge(store_id: params[:store_id], status: 0)
  end

  def change_status
    shift_section = ShiftSection.find_by(store_id: params[:store_id], beginning: params[:beginning])
    shift_section.status = params[:status]
    shift_section.save
    redirect_to "/stores/#{params[:store_id]}/shifts/#{params[:beginning]}"
  end

  def index
    @store_shift_sections = ShiftSection.where(store_id: params[:store_id])
    @store = Store.find(params[:store_id])
  end

  def new
    @store = Store.find(params[:store_id])
    @shift_section = ShiftSection.new
    @shift_section_status_012 = ShiftSection.find_by(store_id: @store.id, status: 0..2)
  end

  def create
    @store = Store.find(params[:store_id])
    @shift_section = ShiftSection.new(shift_section_params)
    if @shift_section.save
      redirect_to "/stores/#{params[:store_id]}/store_month_schedules/#{@shift_section.beginning}/new"
    else
      render :new
    end
  end

  def destroy
    shift_section = ShiftSection.find(params[:id])
    shift_section.destroy
    redirect_to store_shift_section_index_path(params[:store_id])
  end
end
