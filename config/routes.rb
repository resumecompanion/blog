Blog::Engine.routes.draw do

  devise_for :blog_user,
             :class_name => "Blog::User",
             :path => 'users',
             :controllers => { :sessions => "blog/sessions" },
             :skip => [:passwords],
             :path_names => { :sign_out => 'logout', :sign_in => 'login' }

  namespace :admin do
    resources :settings
    resources :users
    resources :navigations
    resources :images
    resources :posts, :except => [:show]
    resources :ckeditor, :only => [:index, :create]
    resources :sidebars
    resources :tags, :only => [:index, :edit, :update]

    root :to => 'users#index'
  end

  unless Rails.env.development?
    match "*initial_path", to: redirect {|params, req| req.url.gsub(/^https/, 'http')}, constraints: lambda {|request| request.ssl?}
  end

  get '/posts', to: redirect('/blog'), constraints: lambda { |request| request.params[:page].nil? && !request.ssl? && request.format != 'rss' }
  get '/posts/:id' => redirect {|params, request| Blog::Engine.routes._generate_prefix({}) + "/#{params[:id]}" }
  resources :posts, :only => [:index, :show], path: '', constraints: lambda { |request| request.format != 'rss' }
  get '/posts.rss', to: 'posts#index', constraints: lambda { |request| request.format == 'rss' }


  resources :tags, :only => [:show]

  match "/404" => "posts#render_404"

  root :to => 'posts#index'

end
