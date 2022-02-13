# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

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
    resources :answers, concerns: %i[vote commented], shallow: true do
      post :best_answer, on: :member
    end
  end

  resources :users, only: :show_rewards do
    get :show_rewards, on: :member
  end

  mount ActionCable.server => '/cable'
end
