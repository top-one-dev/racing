Rails.application.routes.draw do

  resources :cyclists
  
  resources :races do
    resources :stages do
      resources :segments
    end
    resources :rosters, only: [:index, :create, :destroy]
  end

  root 'statics#home'
end
