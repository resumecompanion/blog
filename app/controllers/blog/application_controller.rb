module Blog
  class ApplicationController < ActionController::Base

    before_filter :find_recent_posts
    before_filter :get_ga_account
    before_filter :prepend_view_path_for_theme
    helper_method :global_theme
    layout :set_layout

    def require_admin
      redirect_to blog.root_path unless blog_user_signed_in? && current_blog_user.is_admin?
    end

    def find_recent_posts
      @recent_posts = Blog::Post.where("is_published = true and published_at < '#{Time.now()}'").order("published_at DESC").limit(3)
    end

    def get_setting(key)
      Blog::Setting.find_by_key(key).try(:value)
    end

    def get_ga_account
      @ga_account = get_setting("global:ga_account")
    end

    def global_theme
      @theme ||= get_setting("global:theme")
    end

    protected
    def prepend_view_path_for_theme
      prepend_view_path "#{Blog::Engine.root}/app/views/#{global_theme}"
    end

    def set_layout
      "blog/#{global_theme}"
    end
  end
end
