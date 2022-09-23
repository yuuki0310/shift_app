class AffiliationApplicationController < ApplicationController

  before_action :current_user_authenticate, :store_affiliation

  def affiliation_application_params
    params.require(:affiliation_application).permit(:store_id)
  end

  def new
    @affiliation_application = AffiliationApplication.new
    @user = User.find(params[:user_id])
  end

  def create
    store = Store.find_by(public_uid: affiliation_application_params[:store_id])
    @affiliation_application = AffiliationApplication.new(user_id: params[:user_id], store_id: store.id)
    if @affiliation_application.save
      redirect_to user_path(params[:user_id])
      flash[:notice] = "申請完了しました"
    else
      render controller: :affiliation, action: :new
    end
  end
  
end
