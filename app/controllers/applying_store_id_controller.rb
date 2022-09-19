class ApplyingStoreIdController < ApplicationController

  def applying_store_id_params
    params.require(:applying_store_id).permit(:store_public_uid)
  end

  def create
    store = Store.find_by(public_uid: applying_store_id_params[store_public_uid])
    @applying_store_id = ApplyingStoreId.new(user_id: params[:user_id], store_id: store.id)
    if @applying_store_id.save
      redirect_to user_path(param[:user_id])
      flash[:notice] = "申請中です"
    else
      render controller: :affiliation, action: :new
    end
  end
end
