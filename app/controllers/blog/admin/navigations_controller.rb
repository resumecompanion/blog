module Blog
  module Admin
    class NavigationsController < ApplicationController
      layout "blog/admin"

      before_filter :require_admin
      before_filter :find_navigation, :only => [:edit, :update, :destroy]

      def index
        @navigations = Blog::Navigation.order("position ASC")
      end

      def new
        @navigation = Blog::Navigation.new(:position => Blog::Navigation.all.size + 1)
        @navigations = Blog::Navigation.order("position ASC")
      end

      def create
        @navigation = Blog::Navigation.new(params[:navigation])
        if @navigation.save
          redirect_to blog.admin_navigations_path
        else
          @navigations = Blog::Navigation.order("position ASC")
          render :action => :new
        end
      end

      def edit
        @navigations = Blog::Navigation.where("id != ?", @navigation.id).order("position ASC")
      end

      def update
        if @navigation.update_attributes(params[:navigation])
          redirect_to blog.admin_navigations_path
        else
          @navigations = Blog::Navigation.where("id != ?", @navigation.id).order("position ASC")
          render :action => :edit
        end
      end

      def destroy
        @navigation.destroy
        redirect_to blog.admin_navigations_path
      end

      protected

      def find_navigation
        @navigation = Blog::Navigation.find(params[:id])
      end
    end
  end
end
