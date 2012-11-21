module Blog
  module Admin
    class TagsController < ::Blog::ApplicationController
      layout "blog/admin"

      before_filter :require_admin
      before_filter :find_tag, :only => [:edit, :update]

      def index
        @tags = Blog::Tag.page(params[:page])
      end

      def edit
        @tag = Blog::Tag.find(params[:id])
      end

      def update
        if @tag.update_attributes(params[:tag])
          redirect_to blog.admin_tags_path
        else
          render :action => :edit
        end
      end

      protected

      def find_tag
        @tag = Blog::Tag.find(params[:id])
      end
    end
  end
end