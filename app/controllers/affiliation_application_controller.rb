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
    @affiliation_application = AffiliationApplication.new
    @user = User.find(params[:user_id])
    store = Store.find_by(public_uid: affiliation_application_params[:store_id])
    if store
      @affiliation_application = AffiliationApplication.create(user_id: params[:user_id], store_id: store.id)
      redirect_to user_path(params[:user_id])
      flash[:notice] = "申請完了しました"
    else
      flash[:notice] = "ストアIDが存在しません"
      render controller: :affiliation, action: :new
    end
    # if @affiliation_application.save
    # else
    # end
  end
  
end
