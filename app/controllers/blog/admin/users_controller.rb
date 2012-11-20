module Blog
  module Admin
    class UsersController < ::Blog::ApplicationController
      layout "blog/admin"

      before_filter :require_admin
      before_filter :find_user, :only => [:show, :edit, :update, :destroy]

      def index
        @users = Blog::User.all
      end

      def show
      end

      def new
        @user = Blog::User.new
      end

      def create
        @is_admin = String.new(params[:user][:is_admin])
        @user = Blog::User.new(params[:user], :without_protection => true)

        if @user.save
          redirect_to blog.admin_users_path
        else
          render :action => :new
        end
      end

      def edit
      end

      def update
        if @user.update_attributes(params[:user], :without_protection => true)
          redirect_to blog.admin_users_path
        else
          render :action => :edit
        end
      end

      def destroy
        #TODO we should move the page which was created by @user
        @user.destroy
        redirect_to blog.admin_users_path
      end

      protected

      def find_user
        @user = Blog::User.find(params[:id])
      end

    end
  end
end
