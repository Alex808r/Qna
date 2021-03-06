# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'search', action: :search, controller: 'sphinx_search'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
        # get :all_users, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  namespace :users do
    get '/set_email', to: 'emails#new'
    post '/set_email', to: 'emails#create'
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  concern :vote do
    member do
      put :vote_up
      put :vote_down
      delete :vote_cancel
    end
  end

  concern :commented do
    member do
      post :create_comment
    end
  end

  resources :questions, concerns: %i[vote commented] do
    resources :subscriptions, only: %i[create destroy], shallow: true
    resources :answers, only: %i[create edit update destroy], concerns: %i[vote commented], shallow: true do
      post :best_answer, on: :member
    end
  end

  resources :users, only: :show_rewards do
    get :show_rewards, on: :member
  end

  mount ActionCable.server => '/cable'
end
