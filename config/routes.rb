Rails.application.routes.draw do

  # These routes all deal with the administration of the system.
  # post 'movies/:id' => 'movies#update'

  # resources :movies
  # resources :users
  # resources :login
  # get  '/logout'                  => 'login#destroy'

  # ---------------------------------------------------------------------------

  # This block of resources handles the entire process of a student
  # checking in -> verifying/adding info -> completing attendance.
  resources :events, except: [:edit] do
    resources :checkins, only: [:new, :create]
    resources :attendances #, only: [:new, :create]
    resources :students  #, only: [:show, :new, :edit, :create, :update]
  end

  # ---------------------------------------------------------------------------
  
  post "/events/:id/attendances/create" => 'attendances#create'
  root to: 'users#index'
end
