module Blog
  module Admin
    class SidebarsController < ::Blog::ApplicationController
      layout "blog/admin"

      before_filter :require_admin
      before_filter :find_sidebar, :only => [:show, :edit, :update]

      def index
        @sidebars = Blog::Sidebar.all
      end

      def new
        @sidebar = Blog::Sidebar.new
      end

      def create
        @sidebar = Blog::Sidebar.new(params[:sidebar])
        if @sidebar.save
          redirect_to blog.admin_sidebars_path
        else
          render :action => :new
        end
      end

      def edit
      end

      def update
        if @sidebar.update_attributes(params[:sidebar])
          redirect_to blog.admin_sidebars_path
        else
          render :action => :edit
        end
      end

      protected

      def find_sidebar
        @sidebar = Blog::Sidebar.find(params[:id])
      end
    end
  end
end
