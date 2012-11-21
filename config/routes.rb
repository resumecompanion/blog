Blog::Engine.routes.draw do
  devise_for :blog_user,
             :class_name => "Blog::User",
             :path => 'users',
             :controllers => { :sessions => "blog/sessions" },
             :skip => [:passwords],
             :path_names => { :sign_out => 'logout', :sign_in => 'login' }

  namespace :admin do
    resources :users
    resources :navigations
    resources :images
    resources :posts, :except => [:show]
    resources :ckeditor, :only => [:index, :create]
    resources :sidebars

    root :to => 'users#index'
  end

  resources :posts, :only => [:index, :show]

  root :to => 'posts#index'
end
