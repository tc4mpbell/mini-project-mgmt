Rails.application.routes.draw do
  namespace :api do
    get 'teamwork/login'
    get 'teamwork/sync-tasks-to-teamwork'
  end

# root to: 'devise/sessions#new'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :user do
    authenticated :user do
      root 'organizations#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :projects
  resources :tasks
end
