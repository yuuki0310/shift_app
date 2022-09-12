class ShiftSectionController < ApplicationController

  def index
    @store_shift_sections = StoreShiftSubmission.where(store_id: params[:store_id])
    @store = Store.find(params[:store_id])
  end

end
