class StoresController < ApplicationController
  before_action :logged_in_user
  
  def show
    @store = Store.find(params[:id])
  end
  
end
