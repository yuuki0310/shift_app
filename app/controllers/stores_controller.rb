class StoresController < ApplicationController
  before_action :logged_in_user

  def approve_staff
    user = User.find(params[:user_id])
    user.store_id = params[:store_id]
    user.save
    redirect_to store_path(params[:store_id])
  end
  
  def show
    @store = Store.find(params[:id])
    @affiliation_applications = AffiliationApplication.where(store_id: params[:id])
  end
  
end
