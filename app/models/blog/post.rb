module Blog
  class Post < ActiveRecord::Base
    attr_accessible :author_id, :sidebar_id, :title, :slug, :meta_description,
                    :meta_keywords, :content, :excerpt, :is_published, :published_at,
                    :old_id, :generate_slug, :post_tags, :meta_title
    attr_accessor :generate_slug, :post_tags

    paginates_per 10

    belongs_to :author, :class_name => "Blog::User", :foreign_key => :author_id
    belongs_to :sidebar, :class_name => "Blog::Sidebar", :foreign_key => :sidebar_id

    has_many :post_tag_relations
    has_many :tags, :through => :post_tag_relations

    before_save :set_meta_title
    before_create :handle_slug
    before_save :handle_tags

    validates_presence_of :author_id, :title

    define_index do
      indexes title, :as => :title
      indexes content, :as => :content
      index published_at, :as => :published_at, :sortable => true
      has published_at
    end

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

    def set_meta_title
      self.meta_title = self.title if self.meta_title.blank?
    end

    def handle_slug
      if generate_slug != false
        self.slug = slug.to_url
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
