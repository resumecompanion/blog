module Blog
  module ApplicationHelper

    def render_blog_page_title(title)
      content_tag("title", title)
    end

    def render_blog_meta_description(meta_description)
      tag(:meta, {:name => "description", :content => meta_description})
    end

    def render_blog_meta_keywords(meta_keywords)
      tag(:meta, {:name => "keywords", :content => meta_keywords})
    end
  end
end