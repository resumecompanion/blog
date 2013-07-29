module Blog
  class PostsController < Blog::ApplicationController
    def index
      @posts = Blog::Post.includes(:author).where("is_published = true and published_at < '#{Time.now()}'").order("published_at DESC").page(params[:page]).per(10)

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
        redirect_to :action => :render_404
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
    end
  end
end
