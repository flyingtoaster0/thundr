LakeheadScheduler::Application.routes.draw do

  resources :users


  match '/signup'  => 'users#new',            :via => [:get]
  match '/signin'  => 'sessions#new',         :via => [:get]
  match '/signout' => 'sessions#destroy',     :via => [:delete]
  resources :sessions, only: [:create]

  match '/about' => 'info#about', :via => [:get]
  match '/faq' => 'info#faq', :via => [:get]
  match '/contact' => 'info#contact', :via => [:get]




  get "home/index"

  match '/admin/:id/launch_update', :to => 'admin#launch_update', :as => 'launch_update', :via => [:get]
  match '/admin/:id/confirm', :to => 'admin#confirm', :as => 'confirm', :via => [:get]
  resources :admin

  get 'search' => 'search#index'

  resources :departments
  resources :sections
  #resources :courses

  match 'courses/:search' => 'courses#search', :via => [:get]
  match 'courses/:department_id/:id' => 'courses#show', :via => [:get]


  #resources :departments, :path => 'courses' do
  #  match 'courses/search' => 'courses#search', :via => 'get'
  #  resources :courses, :path => ''


  #end





  namespace :api, :defaults => {:format => :json} do
    resources :departments
    match '/login'                                       => 'users#login',                       :via => [:get]
    match '/courses'                                     => 'courses#index',                     :via => [:get]
    match '/courses/department/:department_id'           => 'courses#find_by_department',        :via => [:get]
    match '/courses/:department_id/:course_id'           => 'courses#show',                      :via => [:get]
    match '/courses/:department_id/:course_id/:section'  => 'courses#full_course',               :via => [:get]
    match '/classes/:department_id/:course_id/:section'  => 'courses#classes',                   :via => [:get]
    match '/course_info/:department_id/:course_id'       => 'courses#course_info',                  :via => [:get]
    match 'search/:q'                                    => 'courses#search',                    :via => [:get]
  end


  root :to => 'home#index'

end
