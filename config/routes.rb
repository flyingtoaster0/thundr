LakeheadScheduler::Application.routes.draw do

  resources :users
  resources :sessions, only: [:new, :create, :destroy]


  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  match '/about', to: 'info#about'
  match '/faq', to: 'info#faq'
  match '/contact', to: 'info#contact'



  get "home/index"

  match '/admin/:id/launch_update', :to => 'admin#launch_update', :as => 'launch_update', via: 'get'
  match '/admin/:id/confirm', :to => 'admin#confirm', :as => 'confirm', via: 'get'
  resources :admin

  get 'search' => 'search#index'

  resources :departments

  resources :departments, :path => 'courses' do
    resources :courses, :path => ''
  end


  namespace :api, :defaults => {:format => :json} do
    resources :departments
    match '/courses',                            to: 'courses#index',                     via: 'get'
    match '/courses/department/:department_id',  to: 'courses#find_by_department',        via: 'get'
    match '/courses/:department_id/:course_id',  to: 'courses#show',                      via: 'get'
    match 'search/:q',                              to: 'courses#search',                    via: 'get'
  end


  root :to => 'home#index'

end
