class SubmissionController < ApplicationController
  def create
    @submission = Submission.new(user_id: @current_user.id)
    @submission.save
    redirect_to("/user_unable_schedules/new")
  end
  
  def destroy
    @submission = Submission.find_by(user_id: @current_user.id)
    @submission.destroy
    redirect_to("/user_unable_schedules/new")
  end
end