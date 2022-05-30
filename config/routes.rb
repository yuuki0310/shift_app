Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "schedules" => "schedules#people"
  post "schedules/week_set" => "schedules#week_set"
end
