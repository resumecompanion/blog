module Blog
  class Tag < ActiveRecord::Base
    attr_accessible :name, :slug, :meta_description, :meta_keywords, :generate_slug, :is_enabled
    attr_accessor :generate_slug

    paginates_per 20

    has_many :post_tag_relations
    has_many :posts, :through => :post_tag_relations

    before_create :handle_slug

    validates_presence_of :name

    def to_param
      self.slug
    end

    protected

    def handle_slug
      if generate_slug != false
        self.slug = name.to_url
        if self.slug.present?
          same_pages_count = self.class.where(:slug => slug).size
          self.slug = "#{self.slug}-#{same_pages_count}" if same_pages_count > 0
        else
          self.errors.add(:name, "can't generate slug")
          return false
        end
      end
    end
  end
end
