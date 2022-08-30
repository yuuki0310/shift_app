Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :login, only: [:new, :create]
  delete '/logout',  to: 'login#destroy'
  resources :stores, except: [:index] do
    resources :store_schedules, :store_month_schedules, only: [:new, :create, :destroy]
    resources :store_submission, only: [:create, :destroy]
    resources :shifts, only: [:index, :create, :destroy] do
      collection do
        get ':date/:working_time_from/edit', action: 'edit'
      end
    end
  end
  resources :users, only: [:show, :new, :create, :edit] do
    resources :user_schedules, :user_unable_schedules, only: [:new, :create, :destroy]
    resources :submission, only: [:create, :destroy]
  end
end
