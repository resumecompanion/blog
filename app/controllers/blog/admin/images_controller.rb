module Blog
  module Admin
    class ImagesController < ApplicationController
      layout "blog/admin"
      before_filter :require_admin
      before_filter :find_file, :only => [:show, :edit, :update, :destroy]

      def index
        @files = Blog::File.page(params[:page]).order("id DESC")
      end

      def show
      end

      def new
        @file = Blog::File.new
      end

      def create
        @file = Blog::File.new(params[:file])
        @file.user = current_blog_user
        if @file.save
          redirect_to blog.admin_images_path
        else
          render :action => :new
        end
      end

      def edit
      end

      def update
        if @file.update_attributes(params[:file])
          redirect_to blog.admin_images_path
        else
          render :action => :edit
        end
      end

      def destroy
        @file.destroy
        redirect_to blog.admin_images_path
      end

      protected

      def find_file
        @file = Blog::File.find(params[:id])
      end
    end
  end
end
