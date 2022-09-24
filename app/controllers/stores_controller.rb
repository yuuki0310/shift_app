class StoresController < ApplicationController
  before_action :owner_permission, only: [:approve_staff]
  before_action :store_staff, only: [:show]

  def store_params
    params.require(:store).permit(:name).merge(owner_id: current_user.id)
  end


  def approve_staff
    user = User.find(params[:user_id])
    user.store_id = params[:store_id]
    user.save
    user.affiliation_application.destroy
    redirect_to store_path(params[:store_id])
  end
  
  def show
    @store = Store.find(params[:id])
    @affiliation_applications = AffiliationApplication.where(store_id: params[:id])
  end

  def new
    @store = Store.new
  end
  
  def create
    @store = Store.new(store_params)
    if @store.save
      owner = @store.owner
      owner.store_id = @store.id
      owner.save
      redirect_to store_path(@store)
    else
      render :new
    end
  end
  
end
