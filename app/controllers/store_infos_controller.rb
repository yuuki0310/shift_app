class StoreInfosController < ApplicationController
  def new
    @week = StoreInfo.new()
    # redirect_to("/")
  end

  def create
    @week = StoreInfo.new()
  end
end
