module Blog
  class PostsController < ApplicationController
    def index
      @posts = Blog::Post.where("is_published = true and published_at < '#{Time.now()}'").order("published_at DESC").page(params[:page])
      # default posts
      @title = nil
      @meta_description = nil
      @meta_keywords = nil
    end

    def show
      @post = Blog::Post.find(params[:id])
      @title = @post.title
      @meta_description = @post.meta_description
      @meta_keywords = @post.meta_keywords
    end
  end
end
