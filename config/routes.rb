# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  resources :questions do
    resources :answers, shallow: true do
      post :best_answer, on: :member
    end
  end

  resources :users, only: :show_rewards do
    get :show_rewards, on: :member
  end
end
