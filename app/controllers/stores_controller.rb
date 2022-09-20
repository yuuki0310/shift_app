class StoresController < ApplicationController
  before_action :logged_in_user
  
  def show
    @store = Store.find(params[:id])
    @affiliation_applications = AffiliationApplication.where(store_id: params[:id])
  end
  
end
