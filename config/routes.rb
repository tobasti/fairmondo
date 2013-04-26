Fairnopoly::Application.routes.draw do
  
  resources :auction_templates, :except => [:show, :index]

  mount Tinycms::Engine => "/cms"

  devise_for :user, controllers: { registrations: 'registrations' }

  resources :auctions do
    member do
      get 'activate'
      get 'deactivate'
      get 'report'
    end
    collection do
      get 'sunspot_failure'
      get 'autocomplete'
    end
  end

  get "welcome/index"

  #the user routes
 
  match 'dashboard' => 'dashboard#index'

  get 'dashboard/edit_profile'

  
   
  resources :users, :only => [:show,:edit] do
    resources :libraries, :except => [:new,:edit]  
    resources :library_elements, :except => [:new, :edit]
    member do
      get 'sales'
      get 'profile'
     
    end
  end
  
   
  root :to => 'welcome#index'
  ActiveAdmin.routes(self) # Workaround for double root https://github.com/gregbell/active_admin/issues/2049

  
  # TinyCMS Routes Catchup
  scope :constraints => lambda {|request|
    request.params[:id] && !["assets","system","admin","public","favicon.ico"].any?{|url| request.params[:id].match(/^#{url}/)}
  } do
    match "/*id" => 'tinycms/contents#show'
  end
  
end
