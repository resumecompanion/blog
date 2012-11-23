# desc "Explaining what the task does"
# task :blog do
#   # Task goes here
# end

namespace :blog do
  desc "Import Blog data"
  task :import => :environment do

    # For Open Uri
    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0

    config = YAML.load_file("#{Rails.root}/config/database.yml")[Rails.env]
    database_config = HashWithIndifferentAccess.new(config)

    client = Mysql2::Client.new(:host => database_config[:host] || "localhost", :username => database_config[:username], :password => database_config[:password], :database => database_config[:database])


    # # Blog Posts
    results = client.query("select * from refinery_blog_posts order by id ASC", :as => :hash, :symbolize_keys => true)

    results.each do |result|
      result_seo = client.query("select * from seo_meta where seo_meta_id = #{result[:id]} and seo_meta_type = 'Refinery::Blog::Post'", :as => :hash, :symbolize_keys => true).first

      # body
      body = Nokogiri::HTML.fragment(result[:body])

      body.css('a').each do |link|
        if match = link[:href].match(/^http:\/\/resumecompanion.com\/resume\/pages(.*)/)
          link[:href] = "/resume#{match[1]}"
        elsif match = link[:href].match(/^\/resume\/pages(.*)/)
          link[:href] = "/resume#{match[1]}"
        elsif match = link[:href].match(/^http:\/\/resumecompanion.com\/resume\/blog\/feed.rss/)
          link[:href] = "http://resumecompaniom.com/blog/posts.rss"
        elsif match = link[:href].match(/^http:\/\/resumecompanion.com\/resume\/blog\/posts\/(.*)/)
          link[:href] = "/blog/posts/#{match[1]}"
        end
      end

      body.css('img').each do |img|
        url = img[:src].match("http:\/\/") ? img[:src] : "http://resumecompanion.com#{img[:src]}"

        puts url
        temp_file = File.open open(url)
        file = Blog::File.new
        file.blog_user_id = 1
        file.title = img[:title] if img[:title].present?
        file.image = temp_file
        file.save

        img[:src] = file.image.url
      end

      # custom_teaser

      excerpt = Nokogiri::HTML.fragment(result[:custom_teaser])

      excerpt.css('a').each do |link|
        url = link[:href]

        temp_file = File.open open(url)
        file = Blog::File.new
        file.blog_user_id = 1
        file.image = temp_file
        file.save

        link[:href] = file.image.url
      end

      excerpt.css('img').each do |img|
        puts img[:src]

        url = img[:src].match("http:\/\/") ? img[:src] : "http://resumecompanion.com#{img[:src]}"

        puts url
        temp_file = File.open open(url)
        file = Blog::File.new
        file.blog_user_id = 1
        file.title = img[:title] if img[:title].present?
        file.image = temp_file
        file.save

        img[:src] = file.image.url
      end

      post = Blog::Post.new
      post.title = result[:title]
      post.slug = result[:slug]
      post.excerpt = excerpt.inner_html
      post.content = body.inner_html
      post.meta_description = result_seo[:meta_description]
      post.meta_keywords = result_seo[:meta_keywords]
      post.published_at = result[:published_at]
      post.sidebar_id = 1
      post.author_id = 1
      post.old_id = result[:id]
      post.generate_slug = false
      post.save

    end

    puts "Import posts"

    # Blog Tags

    results = client.query("select * from tags", :as => :hash, :symbolize_keys => true)

    results.each do |result|
      tag = Blog::Tag.new
      tag.name = result[:name]
      tag.old_id = result[:id]
      tag.save

      # Blog Posts & Tags Relation

      tag_post_relations = client.query("select * from taggings where tag_id = #{tag.old_id} and taggable_type = 'Refinery::Blog::Post'", :as => :hash, :symbolize_keys => true)

      tmp_post_ids = []

      tag_post_relations.each do |tag_post_relation|
        post = Blog::Post.find_by_old_id(tag_post_relation[:taggable_id])
        tmp_post_ids << post.id
      end

      tag.post_ids = tmp_post_ids
    end

    puts "Import tags and relation"
  end
end
