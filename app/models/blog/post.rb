module Blog
  class Post < ActiveRecord::Base
    attr_accessible :author_id, :sidebar_id, :title, :slug, :meta_description,
                    :meta_keywords, :content, :excerpt, :is_published, :published_at,
                    :old_id, :generate_slug
    attr_accessor :generate_slug

    belongs_to :author, :class_name => "Blog::User", :foreign_key => :author_id
    belongs_to :sidebar, :class_name => "Blog::Sidebar", :foreign_key => :sidebar_id

    before_create :handle_slug

    protected

    def handle_slug
      if generate_slug != false
        self.slug = title.to_url
        if self.slug.present?
          same_pages_count = self.class.where(:slug => slug).size
          self.slug = "#{self.slug}-#{same_pages_count}" if same_pages_count > 0
        else
          self.errors.add(:title, "can't generate slug")
          return false
        end
      end
    end
  end
end