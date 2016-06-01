module Blog
  class File < ActiveRecord::Base
    attr_accessible :image, :title, :filename

    mount_uploader :image, ImageUploader
    paginates_per 48

    validates_presence_of :image

    belongs_to :user, :foreign_key => :blog_user_id

    scope :page, Proc.new {|num| limit(default_per_page).offset(default_per_page * ([num.to_i, 1].max - 1)) } do
      def total_count #:nodoc:
        @total_count ||= begin
        c = except(:offset, :limit, :order)

        c = c.except(:includes) unless references_eager_loaded_tables?

        uses_distinct_sql_statement = c.to_sql =~ /DISTINCT/i
          if uses_distinct_sql_statement
            c.length
          else
            c = c.count
            c.respond_to?(:count) ? c.count : c
          end
        end
      end
      include Kaminari::ActiveRecordRelationMethods
      include Kaminari::PageScopeMethods
    end
    

    def filename=(filename)
      self.image.rename(filename) if filename.present?
    end

    def filename
      ::File.basename(self.image.path).split(".").first
    end
  end
end
