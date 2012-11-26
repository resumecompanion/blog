module Blog
  class TagsController < ApplicationController
    def show
      @tag = Blog::Tag.find_by_slug_and_is_enabled(params[:id], true)
      @posts = @tag.posts.page(params[:page])

      @title = "Tag:#{@tag.name}"
      @meta_description = @tag.meta_description
      @meta_keywords = @tag.meta_keywords
    end
  end
end
