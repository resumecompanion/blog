module Blog
  class PostTagRelation < ActiveRecord::Base
    belongs_to :posts, :class_name => "Blog::Post", :foreign_key => "post_id"
    belongs_to :tags, :class_name => "Blog::Tag", :foreign_key => "tag_id"
  end
end
