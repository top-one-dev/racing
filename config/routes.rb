Rails.application.routes.draw do

  get '/admin', to: 'admin#index'
  get 'admin/logout', to: 'admin#destroy'
  post 'admin/login', to: 'admin#authorize'

  get 'results(.:format)', to: 'results#index'

  get 'results/races/:id(.:format)', to: 'results#manage', as: 'manage_result'

  get 'results/races/:race_id/stages/:id(.:format)', to: 'results#stage_results', as: 'stage_results'

  #new stage_effort 
  get 'results/races/:race_id/stages/:stage_id/cyclists/:cyclist_id/stage_efforts/new(.:format)', to: 'stage_efforts#new', as: 'new_stage_effort'
  post 'results/races/:race_id/stages/:stage_id/cyclists/:cyclist_id/stage_efforts(.:format)', to: 'stage_efforts#create', as: 'stage_efforts'  
  get 'results/races/:race_id/stages/:stage_id/cyclists/:cyclist_id/stage_efforts/:id/edit(.:format)', to: 'stage_efforts#edit', as: 'edit_stage_effort'
  put 'results/races/:race_id/stages/:stage_id/cyclists/:cyclist_id/stage_efforts/:id(.:format)', to: 'stage_efforts#update'
  patch 'results/races/:race_id/stages/:stage_id/cyclists/:cyclist_id/stage_efforts/:id(.:format)', to: 'stage_efforts#update', as: 'update_stage_effort'
  delete 'results/races/:race_id/stages/:stage_id/cyclists/:cyclist_id/stage_efforts/:id(.:format)', to: 'stage_efforts#destroy', as: 'destroy_stage_effort'

  resources :cyclists
  get '/auth', to: 'sessions#create'
  get '/token_exchange', to: 'sessions#get_token'
  get '/deauth', to: 'sessions#deauth'
  #resources :stage_efforts
  
  resources :races do
    resources :stages, except: :index do
      resources :segments
    end
    resources :rosters, only: [:index, :create, :destroy]
  end

  root 'statics#home'
end
