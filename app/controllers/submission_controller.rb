class SubmissionController < ApplicationController
  before_action :logged_in_user
  
  def create
    @submission = Submission.new(user_id: @current_user.id)
    @submission.save
    redirect_to new_user_user_unable_schedule_path
  end
  
  def destroy
    @submission = Submission.find_by(user_id: @current_user.id)
    @submission.destroy
    redirect_to new_user_user_unable_schedule_path
  end
end