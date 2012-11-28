module Blog
  class PostsController < ApplicationController
    def index
      @posts = Blog::Post.where("is_published = true and published_at < '#{Time.now()}'").order("published_at DESC").page(params[:page]).per(10)

      respond_to do |format|
        format.html {
          @title = params[:page].present? ? "#{Blog::Setting.find_by_key("global:meta_title").try(:value)} - Page #{params[:page]}" : Blog::Setting.find_by_key("global:meta_title").try(:value)
          @meta_description = params[:page].present? ? "#{Blog::Setting.find_by_key("global:meta_description").try(:value)} - Page #{params[:page]}" : Blog::Setting.find_by_key("global:meta_description").try(:value)
          @meta_keywords = Blog::Setting.find_by_key("global:meta_keywords").try(:value)

          @sidebar_id = Blog::Setting.find_by_key("global:posts:sidebar_id").try(:value)
          @sidebar = Blog::Sidebar.find(@sidebar_id) rescue nil
        }

        format.rss {
          @title = Blog::Setting.find_by_key("global:meta_title").try(:value)
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
      @meta_description = @post.meta_description
      @meta_keywords = @post.meta_keywords

      @disqus_shortname = Blog::Setting.find_by_key("global:disqus:shortname").try(:value)
    end

    def render_404
      @title = "Page not found"
    end
  end
end
