Rails.application.routes.draw do
  get 'store_month_schedules/new'
  get 'store_month_schedules/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :store_schedules, :user_schedules, :store_month_schedules
end
