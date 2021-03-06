Rails.application.routes.draw do

  get 'bases/index'

  root 'static_pages#top'
  get  '/signup', to: 'users#new'
  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get '/edit-basic-info/:id', to: 'users#edit_basic_info', as: :basic_info
  patch 'update-basic-info', to: 'users#update_basic_info'
  
  get 'users/:id/attendances/:date/edit', to: 'attendances#edit', as: :edit_attendances
  patch 'users/:id/attendances/:date/update', to: 'attendances#update', as: :update_attendances
  
  get 'users/:id/attendances/:id/edit_overtime', to: 'attendances#edit_overtime', as: :edit_overtime
  patch 'users/:id/attendances/:id/update_overtime', to: 'attendances#update_overtime', as: :update_overtime
  
  get 'users/:user_id/attendances/:id/edit_overtime_info', to: 'attendances#edit_overtime_info', as: :edit_overtime_info
  patch 'users/:user_id/attendances/:id/update_overtime_info', to: 'attendances#update_overtime_info', as: :update_overtime_info
  
  get '/employees_on_duty', to: 'users#employees_on_duty'
  resources :users do
    collection { post :import }
    resources :attendances, only: :create
  end
  resources :bases
end
