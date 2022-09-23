class ShiftSectionController < ApplicationController

  before_action :store_staff, :store_independent

  def index
    @store_shift_sections = StoreShiftSubmission.where(store_id: params[:store_id])
    @store = Store.find(params[:store_id])
  end

end
