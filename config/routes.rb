# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'api/auth/registrations',
      sessions: 'api/auth/sessions',
    }

    resources :users, only: [:index, :update, :destroy]

    resources :projects, only: [:index, :create, :update, :destroy, :show]

    get '/projects/:id/sponsorships', to: 'projects#list_sponsorships'

    resources :sponsorships, only: [:create]
  end
end
