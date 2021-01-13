Rails.application.routes.draw do
  resources :dogs
  # get 'welcome/index'#, controller: "welcome#index"
  get "/welcome/index", to: "welcome#index"
end
