class StoreShiftSubmissionController < ApplicationController
  before_action :logged_in_user, except:[:crate, :destroy]
  before_action :owner_permission, only: [:create, :destroy]
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
