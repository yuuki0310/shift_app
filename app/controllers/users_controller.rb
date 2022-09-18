class UsersController < ApplicationController

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_user_affiliation_path(@user)
    else
      render :new
    end
  end
end
