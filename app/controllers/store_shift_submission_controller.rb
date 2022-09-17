class StoreShiftSubmissionController < ApplicationController
  before_action :logged_in_user, except:[:crate, :destroy]
  before_action :owner_permission, only: [:create, :destroy]

  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  attribute :beginning, :date
  attribute :ending, :date

  def store_shift_submission_params
    params.require(:store_shift_submission).permit(:beginning, :ending).merge(store_id: params[:store_id], status: 0)
  end

  def change_status
    store_shift_submission = StoreShiftSubmission.find_by(store_id: params[:store_id], beginning: params[:beginning])
    store_shift_submission.status = params[:status]
    store_shift_submission.save
    redirect_to "/stores/#{params[:store_id]}/shifts/#{params[:beginning]}"
  end

  def new
    @store = Store.find(params[:store_id])
    @store_shift_submission = StoreShiftSubmission.new
  end

  def create
    @store = Store.find(params[:store_id])
    @store_shift_submission = StoreShiftSubmission.new(store_shift_submission_params)
    if @store_shift_submission.save
      redirect_to "/stores/#{params[:store_id]}/store_month_schedules/#{@store_shift_submission.beginning}/new"
    else
      render :new
    end
  end

  def destroy
    store_submission = StoreShiftSubmission.find_by(store_id: params[:store_id])
    store_submission.destroy
    redirect_to store_shifts_path(params[:store_id])
  end
end
