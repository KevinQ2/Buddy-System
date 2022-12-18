Rails.application.routes.draw do

  # user_sessions routes
  root "informational_pages#welcome_page"

  # Welcome page
  get "/", to: "informational_pages#welcome_page"

  # admin_mailings routes
  get "communications", to: "admin_mailings#communications"
  get "mail_list", to: "admin_mailings#mail_list"
  get "mail_users", to: "admin_mailings#mail_users"

  # To send email from mailing list
  get "send_email_mailinglist", to: 'admin_mailings#send_email_mailinglist', as: :send_email_mailinglist

  # To send email to registered users
  get "send_email_mailingusers", to: 'admin_mailings#send_email_mailingusers', as: :send_email_mailingusers

  # mailing_list routes
  # To import mailing list
  resources :mailing_list, only: [:index, :destroy, :create, :import, :destroy_all] do
    collection {post :import}
    collection {delete :destroy_all}
  end

  # Enroll in mailing routes
  # To import enroll in mailing
  resources :enroll_in_mailings, only: [:import, :destroy_all] do
    collection { post :import }
    collection { delete :destroy_all }
  end
  get "/enroll_in_mailings/:scheme_id" , to: "enroll_in_mailings#index", as: :enroll_in_mailings
  post "/enroll_in_mailings/:scheme_id" , to: "enroll_in_mailings#send_emails"


  # Enroll in mentee/mentor routes
  resources :enroll_ins, only: [:index, :show]
  get "/mentor/:scheme_id/:link", to: "enroll_ins#new_mentor", as: :enroll_mentor
  post "/mentor/:scheme_id/:link", to: "enroll_ins#create_mentor"
  get "/mentee/:scheme_id/:link", to: "enroll_ins#new_mentee", as: :enroll_mentee
  post "/mentee/:scheme_id/:link", to: "enroll_ins#create_mentee"

  # Show enrolled in for or specific scheme
  get "/enroll_in/show/:scheme_id", to: "enroll_ins#show_scheme_enrolled", as: :show_scheme_enrolled

  # statistics routes
  resources :statistics do
    member do
      get :show_questionnaires
      get :show_answers
    end
  end

  # Department routes
  post 'departments/new', to: 'departments#create'
  patch 'departments/:id/edit', to: 'departments#update'
  delete 'departments/:id/delete', to: 'departments#destroy'
  resources :departments, :only => [:index, :new, :show, :edit] do
    member do
      get :delete
    end
  end

  # Scheme routes
  resources :schemes do
    member do
      get :delete
    end
  end

  # For Code of Conduct individual page
  get '/schemes/:id/codeofconduct' => 'schemes#showcodeofconduct'

  #user verifications
  get '/user/verify', to: 'user_verifications#new'
  post '/user/verify', to: 'user_verifications#create'
  get '/user/code', to: 'user_verifications#newCode'
  post '/user/code', to: 'user_verifications#code'
  get '/user/request-code', to: 'user_verifications#requestCode'


  get '/user/login', to: 'user_sessions#new'
  post '/user/login', to: 'user_sessions#create'
  delete '/user/logout', to: 'user_sessions#destroy'


  # admin_sessions routes
  get '/admin/login', to: 'admin_sessions#new'
  post '/admin/login', to: 'admin_sessions#create'
  delete '/admin/logout', to: 'admin_sessions#destroy'


  # users routes
  resources :users


  # admins routes
  post 'admins/new', to: 'admins#create'
  patch 'admins/:id/edit', to: 'admins#update'
  delete 'admins/:id/delete', to: 'admins#destroy'
  resources :admins, :only => [:index, :new, :show, :edit] do
    member do
      get :delete
    end
  end

  # admin_profiles routes
  get 'admin_profile', to: 'admin_profiles#show', as: 'admin_profile'
  get 'admin_profile/edit', to: 'admin_profiles#edit', as: 'edit_admin_profile'
  patch 'admin_profile/edit', to: 'admin_profiles#update'
  get 'admin_profile/change_password', to: 'admin_profiles#edit_password'
  patch 'admin_profile/change_password', to: 'admin_profiles#update_password'

  # user_profiles routes
  get 'user_profile', to: 'user_profiles#show', as: 'user_profile'
  get 'user_profile/edit', to: 'user_profiles#edit', as: 'edit_user_profile'
  patch 'user_profile/edit', to: 'user_profiles#update'
  get 'user_profile/change_password', to: 'user_profiles#edit_password'
  patch 'user_profile/change_password', to: 'user_profiles#update_password'



  # Routes for publicly accessible/general informational pages
  get "/pages/:page" => "informational_pages#show", as: :informational_pages



  # questions routes
  resources :questions do
    member do
      get :delete
    end
  end


  # answers routes
  resources :answers do
    member do
      get :edit_answers
      get :delete
    end
  end

  # matching routes
  post 'match_mentees_to_mentors', to: 'matches#match_mentees_to_mentors'

  resources :matches , :except => [:new, :create] do
    member do

      get :delete
    end
  end

  # Route for new manual match, create
  get "/matches/new/:scheme_id", to: "matches#new", as: :new_matches
  post "/matches/new/:scheme_id", to: "matches#create"


  # questionnaires routes
  post "/make_copy", to: "questionnaires#make_copy", as: :make_copy

  resources :questionnaires do
    member do
      get :delete
      get :copy
    end
  end

  # coordinators routes
  resources :coordinators, :except => [:index, :edit, :delete] do
    member do
      get :delete
    end
  end

  # Create coordinators for specific scheme
  get "/coordinators/:scheme_id/new", to: "coordinators#new_coordinator", as: :new_scheme_coordinator
  post "/coordinators/:scheme_id/new", to: "coordinators#create_coordinator"
  get "/coordinators/:scheme_id/delete", to: "coordinators#delete_coordinator", as: :delete_scheme_coordinator
  get "/coordinators.:scheme_id", to: "coordinators#index"
  get "/coordinators", to: "coordinators#index_all"
  get "/coordinators/new", to: "coordinators#new"
  post "/coordinators/new", to: "coordinators#create"


  resources :admin_sessions, only: [:new, :create, :destroy]
  get '/login', to: 'admin_sessions#new'
  post '/login', to: 'admin_sessions#create'
  get '/logout', to: 'admin_sessions#destroy'


  get "reports/handled"
  get 'reports/delete', to: 'admin_sessions#destroy'
	resources :reports, except: [:edit]



end
