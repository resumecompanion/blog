module Blog
  class Post < ActiveRecord::Base
    # hack for will_paginate
    ::ActiveRecord::Relation.send :include, Kaminari::ActiveRecordRelationMethods
    ::ActiveRecord::Relation.send :include, Kaminari::PageScopeMethods

    attr_accessible :author_id, :sidebar_id, :title, :slug, :meta_description,
                    :meta_keywords, :content, :excerpt, :is_published, :published_at,
                    :old_id, :generate_slug, :post_tags
    attr_accessor :generate_slug, :post_tags

    paginates_per 10

    belongs_to :author, :class_name => "Blog::User", :foreign_key => :author_id
    belongs_to :sidebar, :class_name => "Blog::Sidebar", :foreign_key => :sidebar_id

    has_many :post_tag_relations
    has_many :tags, :through => :post_tag_relations

    before_create :handle_slug
    before_save :handle_tags

    validates_presence_of :author_id, :title

    def to_param
      self.slug
    end

    def images_sitemap
      ha = []
      doc = Nokogiri::HTML(self.content)
      doc.css('img').each do |img|
        ha << {:loc => img.attr(:src), :title => (img.attr(:title) || img.attr(:alt) || '')}
      end
      ha
    end

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

    def handle_tags
      temp_tag_ids = []
      if self.post_tags.present?
        temp_tag_names = self.post_tags.split(",")
        temp_tag_names.each do |name|
          tag = Blog::Tag.find_or_create_by_name(:name => name.strip)
          temp_tag_ids << tag.id
        end
      end

      self.tag_ids = temp_tag_ids
    end
  end
end