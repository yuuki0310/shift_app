class AffiliationController < ApplicationController

  def new
    @applying_store_id = ApplyingStoreId.new
    @user = User.find(params[:user_id])
  end
  
end
