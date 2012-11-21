module Blog
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

    # Setup accessible (or protected) attributes for your model
    attr_accessible :nickname, :is_admin, :email, :password, :password_confirmation, :remember_me
    # attr_accessible :title, :body

    has_many :posts, :class_name => "Cms::Post", :foreign_key => :author_id
  end
end
