module Blog
  class ApplicationController < ActionController::Base
    def require_admin
      redirect_to blog.root_path unless blog_user_signed_in? && current_blog_user.is_admin?
    end
  end
end
