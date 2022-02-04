# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  concern :vote do
    member do
      put :vote_up
      put :vote_down
      delete :vote_cancel
    end
  end

  resources :questions, concerns: :vote do
    resources :answers, concerns: :vote, shallow: true do
      post :best_answer, on: :member
    end
  end

  resources :users, only: :show_rewards do
    get :show_rewards, on: :member
  end

  mount ActionCable.server => '/cable'
end
