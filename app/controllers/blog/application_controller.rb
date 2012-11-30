module Blog
  class ApplicationController < ActionController::Base

    before_filter :find_recent_posts

    def require_admin
      redirect_to blog.root_path unless blog_user_signed_in? && current_blog_user.is_admin?
    end

    def find_recent_posts
      @recent_posts = Blog::Post.where("is_published = true and published_at < '#{Time.now()}'").order("published_at DESC").limit(10)
    end
  end
end
