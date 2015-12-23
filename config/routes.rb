Rails.application.routes.draw do

  resources :cyclists
  resources :segments
  
  resources :races do
    resources :stages
    resources :rosters, only: [:index, :create, :destroy]
  end

  root 'statics#home'
end
