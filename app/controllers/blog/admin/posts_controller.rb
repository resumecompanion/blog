module Blog
  module Admin
    class PostsController < ::Blog::ApplicationController
      layout "blog/admin"

      before_filter :require_admin
      before_filter :find_post, :only => [:edit, :update, :destroy]

      def index
        @posts = Blog::Post.page(params[:page]).includes(:author).order("published_at desc")
      end

      def new
        @post = Blog::Post.new
        @users = Blog::User.where(:is_admin => true)
      end

      def create
        @post = Blog::Post.new(params[:post])
        if @post.save
          redirect_to blog.admin_posts_path
        else
          @users = Blog::User.where(:is_admin => true)
          render :action => :new
        end
      end

      def edit
        @users = Blog::User.where(:is_admin => true)
      end

      def update
        if @post.update_attributes(params[:post])
          redirect_to blog.admin_posts_path
        else
          @users = Blog::User.where(:is_admin => true)
          render :action => :edit
        end
      end

      def destroy
        @post.destroy
        redirect_to blog.admin_posts_path
      end

      protected

      def find_post
        @post = Blog::Post.find_by_slug(params[:id])
      end
    end
  end
end
