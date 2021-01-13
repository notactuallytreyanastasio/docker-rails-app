Rails.application.routes.draw do
  # get 'welcome/index'#, controller: "welcome#index"
  get "/welcome/index", to: "welcome#index"
end
