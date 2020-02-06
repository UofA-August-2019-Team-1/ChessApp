Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "games#index"
  resources :games do
  	member do
  		post :forfeit_game
  	end
  end
  resources :pieces
  resources :users
end
