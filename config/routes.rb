# frozen_string_literal: true

Rails.application.routes.draw do
  resources :states

  get 'cities/search', to: 'cities#search'
  resources :cities

  root 'cities#index'
end
