module Blog
  class File < ActiveRecord::Base
    attr_accessible :image, :title

    mount_uploader :image, Blog::ImageUploader
    paginates_per 48

    validates_presence_of :image

    belongs_to :user, :foreign_key => :blog_user_id
  end
end
