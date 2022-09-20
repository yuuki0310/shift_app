class UsersController < ApplicationController

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :working_desirred_time, :store_id)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @store = Store.find_by(id: @user.store_id)
    # @affiliation_application = AffiliationApplication.find_by(user_id: )
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to new_user_affiliation_application_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to store_path(@user.id)
  end

end
