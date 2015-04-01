Rails.application.routes.draw do

  resources :wikis do 
    resources :collaborations, only: [:index, :create]
    delete 'collaborations/destroy'
  end

  resources :charges, only: [:new, :create]

  resources :downgrades, only: [:new, :create]

  devise_for :users
  root 'welcome#index'

end