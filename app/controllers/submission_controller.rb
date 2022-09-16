class SubmissionController < ApplicationController
  before_action :logged_in_user, :current_user_authenticate
  
  def create
    user = User.find_by(params[:user_id])
    @store_shift_submission = StoreShiftSubmission.find_by(store_id: user.store.id, beginning: params[:beginning])
    @submission = Submission.create(user_id: @current_user.id, store_shift_submission_id: @store_shift_submission.id)
    redirect_to "/users/#{params[:user_id]}/user_unable_schedules/#{params[:beginning]}/new"
  end
  
  def destroy
    @submission = Submission.find_by(user_id: @current_user.id)
    @submission.destroy
    redirect_to "/users/#{params[:user_id]}/user_unable_schedules/#{params[:beginning]}/new"
  end
end