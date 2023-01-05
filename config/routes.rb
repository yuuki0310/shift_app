Rails.application.routes.draw do
  get 'privacy_policy/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'top#index'
  get "/privacy_policy" => "privacy_policy#index"

  resources :login, only: [:new, :create]
  delete '/logout',  to: 'login#destroy'
  
  resources :stores, except: [:index] do
    post 'approve_staff/:user_id', action: 'approve_staff'
    resources :store_weekly_schedules, only: [:new, :create, :destroy]
    resources :store_month_schedules, only: [:index, :create, :destroy] do
      collection do
        get ':beginning/new', action: 'new'
      end
    end
    
    resources :shift_section, only: [:index, :new, :create, :destroy]
    resources :shifts, only: [:create, :destroy] do
      collection do
        post ':beginning/change_status/:status' => 'shift_section#change_status'
        get ':beginning/:ending/new', action: 'new'
        get ':date/:working_time_from/edit', action: 'edit'
        get ':beginning', action: 'index'
      end
    end
  end

  resources :users, only: [:show, :new, :create, :edit, :update] do
    resources :user_weekly_schedules, :user_unable_schedules, :affiliation_application, only: [:new, :create, :destroy]
    resources :user_unable_schedules, only: [:index, :create, :destroy] do
      collection do
        get ':beginning/new', action: 'new'
      end
    end
    resources :user_submissions, only: [:create, :destroy]
  end
end
