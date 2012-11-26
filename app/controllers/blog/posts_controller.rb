module Blog
  class PostsController < ApplicationController
    def index
      @posts = Blog::Post.where("is_published = true and published_at < '#{Time.now()}'").order("published_at DESC").page(params[:page])
    end

    def show
      @post = Blog::Post.find(params[:id])
    end
  end
end
