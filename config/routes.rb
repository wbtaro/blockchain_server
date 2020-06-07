Rails.application.routes.draw do
  resources :blockchain
  resources :transactions
  get "/mining", to: "blockchain#mining"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
