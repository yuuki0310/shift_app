module LoginHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def store_staff?
    if params[:store_id]
      store_id = params[:store_id]
    elsif params[:id]
      store_id = params[:id]
    end
    store = Store.find(store_id)
    logged_in? && store.id == current_user.store_id
  end

  def owner?
    if params[:store_id]
      store_id = params[:store_id]
    elsif params[:id]
      store_id = params[:id]
    end
    store = Store.find(store_id)
    store.owner == current_user
  end

  def return_user_id
    if params[:user_id]
      return params[:user_id]
    elsif params[:id]
      return params[:id]
    end
  end
  
end
