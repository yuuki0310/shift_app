Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :stores, except: [:index]
  resources :store_schedules, :user_schedules, :store_month_schedules, :user_unable_schedules, only: [:new, :create, :destroy]
  resources :submission, only: [:create, :destroy]
end
