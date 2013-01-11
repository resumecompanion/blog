module Blog
  module ApplicationHelper
    def render_blog_page_title(title)
      title = (title == website_title) ? title : "#{title} | #{website_title}"
      content_tag("title", title)
    end

    def render_blog_meta_description(meta_description)
      tag(:meta, {:name => "description", :content => meta_description})
    end

    def render_blog_meta_keywords(meta_keywords)
      tag(:meta, {:name => "keywords", :content => meta_keywords})
    end

    def website_title
      Blog::Setting.find_by_key("global:website_title").try(:value)
    end

    def render_canonical_url(url)
      tag(:link, :rel => :canonical, :href => @canonical_url) if url
    end
  end
end