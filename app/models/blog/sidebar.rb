module Blog
  class Sidebar < ActiveRecord::Base
    attr_accessible :name, :content

    validates_presence_of :name

    has_many :posts
  end
end
