module Blog
  class TagsController < ApplicationController
    def show
      @tag = Blog::Tag.find_by_slug_and_is_enabled(params[:id], true)

      if @tag.blank?
        redirect_to :controller => :posts, :action => :render_404
        return false
      end

      @posts = @tag.posts.page(params[:page])

      @title = params[:page].present? ? "Tag:#{@tag.name} - Page #{params[:page]}" : "Tag:#{@tag.name}"
      @meta_description = params[:page].present? ? "#{@tag.meta_description} - Page #{params[:page]}" : @tag.meta_description
      @meta_keywords = @tag.meta_keywords
      @canonical_url = blog.tag_url(@tag, :page => params[:page] == "1" ? nil : params[:page])

      @sidebar_id = get_setting("global:tags:sidebar_id")
      @sidebar = Blog::Sidebar.find(@sidebar_id) rescue nil
    end
  end
end
