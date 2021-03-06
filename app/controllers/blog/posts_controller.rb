module Blog
  class PostsController < Blog::ApplicationController
    before_filter :redirect_if_https, only: [:index]
    def index
      @posts = Blog::Post.page(params[:page]).includes(:author).where("is_published = true and published_at < '#{Time.now()}'").order("published_at DESC")

      respond_to do |format|
        format.html {
          @title = params[:page].present? ? "#{get_setting("global:meta_title")} - Page #{params[:page]}" : get_setting("global:meta_title")
          @meta_description = params[:page].present? ? "#{get_setting("global:meta_description")} - Page #{params[:page]}" : get_setting("global:meta_description")
          @meta_keywords = get_setting("global:meta_keywords")

          @sidebar_id = get_setting("global:posts:sidebar_id")
          @sidebar = Blog::Sidebar.find(@sidebar_id) rescue nil

          @canonical_url = blog.posts_url(:page => params[:page] == "1" ? nil : params[:page])
        }

        format.rss {
          @title = get_setting("global:meta_title")
        }
      end
    end

    def show
      @post = Blog::Post.find_by_slug(params[:id])

      if @post.blank?
        @title = "Page not found"
        render 'render_404', status: 404
        return false
      end

      @title = @post.title
      @meta_title = @post.meta_title
      @meta_description = @post.meta_description
      @meta_keywords = @post.meta_keywords
      @canonical_url = blog.post_url(@post)

      @disqus_shortname = get_setting("global:disqus:shortname")
    end

    def render_404
      @title = "Page not found"
      render status: 404
    end

    private
    def redirect_if_https
      redirect_to root_url(protocol: 'http'), status: :moved_permanently if request.ssl?
    end
  end
end
