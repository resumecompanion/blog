module Blog
  module Admin
    class SettingsController < ApplicationController
      layout "blog/admin"

      before_filter :require_admin

      def index
        @settings = Blog::Setting.all
      end

      def edit
        @setting = Blog::Setting.find(params[:id])
      end

      def update
        @setting = Blog::Setting.find(params[:id])
        if @setting.update_attributes(params[:setting])
          redirect_to blog.admin_settings_path
        else
          render :action => :edit
        end
      end
    end
  end
end
