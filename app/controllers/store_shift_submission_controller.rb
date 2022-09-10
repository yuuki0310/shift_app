class StoreShiftSubmissionController < ApplicationController
  before_action :logged_in_user, except:[:crate, :destroy]
  before_action :owner_permission, only: [:create, :destroy]

  def change_status
    store_shift_submission = StoreShiftSubmission.find_by(store_id: params[:store_id], beginning: params[:beginning])
    store_shift_submission.status = params[:status]
    store_shift_submission.save
    redirect_to "/stores/#{params[:store_id]}/shifts/#{params[:beginning]}"
  end

  def create
    StoreShiftSubmission.create(store_id: params[:store_id])
    redirect_to store_shifts_path(params[:store_id])
  end

  def destroy
    store_submission = StoreShiftSubmission.find_by(store_id: params[:store_id])
    store_submission.destroy
    redirect_to store_shifts_path(params[:store_id])
  end
end
