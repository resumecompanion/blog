module Blog
  module Admin
    class CkeditorController < ::Blog::ApplicationController
      before_filter :require_admin
      layout "blog/simple"

      def index
        @files = Blog::File.page(params[:page]).order("id DESC")
      end

      def create
        @file = Blog::File.new
        @file.image = params[:upload]
        @file.blog_user_id = params[:user_id]
        @file.save
      end
    end
  end
end
