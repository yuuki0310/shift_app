class StoreSubmissionController < ApplicationController
  def create
    StoreSubmission.create(store_id: params[:store_id])
    redirect_to store_shifts_path(params[:store_id])
  end

  def destroy
    store_submission = StoreSubmission.find_by(store_id: params[:store_id])
    store_submission.destroy
    redirect_to store_shifts_path(params[:store_id])
  end
end
