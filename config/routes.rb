Blog::Engine.routes.draw do
  devise_for :blog_user,
             :class_name => "Blog::User",
             :path => 'users',
             :controllers => { :sessions => "blog/sessions" },
             :skip => [:passwords],
             :path_names => { :sign_out => 'logout', :sign_in => 'login' }

  namespace :admin do
    resources :users
  end

  resources :posts, :only => [:index, :show]

  root :to => 'posts#index'
end
