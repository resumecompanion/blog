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

  desc "create default data"
  task :seed => :environment do

    user = Blog::User.new(:nickname => "admin", :email => "admin@resumecompanion.com", :password => "123456", :password_confirmation => "123456")
    user.is_admin = true
    user.save

    puts "Create admin"

    navigation = Blog::Navigation.create(:name => "Home", :link => "/blog", :link_title => "Home", :is_hidden => false, :position => 1)

    puts "create navigations"

    setting = Blog::Setting.create(:key => "global:website_title", :value => "ResumeCompanion Blog", :description => "This will be your website name")
    setting = Blog::Setting.create(:key => "global:meta_title", :value => "ResumeCompanion Blog", :description => "This is default title if we can't find tilte")
    setting = Blog::Setting.create(:key => "global:meta_description", :value => "ResumeCompanion Blog", :description => "This is default meta description if we can't find meta description")
    setting = Blog::Setting.create(:key => "global:meta_keywords", :value => "ResumeCompanion Blog", :description => "This is default meta description if we can't find meta description")
    setting = Blog::Setting.create(:key => "global:posts:sidebar_id", :value => 1, :description => "This will be your posts' sidebar id")
    setting = Blog::Setting.create(:key => "global:tags:sidebar_id", :value => 1, :description => "This will be your tags' sidebar id")
    setting = Blog::Setting.create(:key => "global:disqus:shortname", :value => "resumebuilder1", :description => "This is for disqus")
    setting = Blog::Setting.create(:key => "global:ga_account", :value => "UA-513849-6", :description => "This is GA account")

    puts "create settings"

    sidebar = Blog::Sidebar.new
    sidebar.name = "default sidebar"
    sidebar.content = '
    <div>
      <p>
        <img alt="" src="/uploads/blog/file/image/112/large_banner1-3dd65ef96b799bd188edf6a3baf428f4.png" style="width: 300px; height: 156px;" /></p>
    </div>
    <div>
      <h3 class="facebook-fan-page">
        Join Us on Facebook</h3>
      <p>
        <iframe allowtransparency="true" frameborder="0" scrolling="no" src="//www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fresumecompanion&amp;width=300&amp;height=285&amp;colorscheme=light&amp;show_faces=true&amp;border_color=%23f0f5fb&amp;stream=false&amp;header=false" style="border:none; overflow:hidden; width:300px; height:285px;"></iframe></p>
    </div>

    <div class="fan-pages">
      <h3>Follow Us!</h3>
      <ul>
        <li><a href="http://www.facebook.com/resumecompanion" class="facebook" target="_blank" title="Facebook">Facebook</a></li>
        <li><a href="http://www.twitter.com/resumecompanion" class="twitter" target="_blank" title="Twitter">Twitter</a></li>
        <li><a href="https://plus.google.com/111264232375433512185" class="google-plus" target="_blank" title="Google Plus">Google Plus</a></li>
        <li><a href="http://resumecompanion.blogspot.com/" class="blogger" target="_blank" title="Blogger">Blogger</a></li>
        <li><a href="http://pinterest.com/resumecompanion/" class="pinterest" target="_blank" title="Pinterest">Pinterest</a></li>
        <li><a href=" https://www.youtube.com/resumecompanionvideo" class="youtube" target="_blank" title="Youtube">Youtube</a></li>
        <li><a href="/blog/posts.rss" class="rss" target="_blank" title="RSS">RSS</a></li>
      </ul>
    </div>

    <div>
      <h3>Resume For Beginners!</h3>
      <ul>
        <li><a href="http://resumecompanion.com" title="Resume 101">Resume 101</a></li>
        <li><a href="http://resumecompanion.com" title="Resume 102">Resume 102</a></li>
        <li><a href="http://resumecompanion.com" title="How to write your resume">How to write your resume</a></li>
      </ul>
    </div>'

    sidebar.save

    puts "create default sidebar"
  end

  task :meta_title => :environment do
    config = YAML.load_file("#{Rails.root}/config/database.yml")[Rails.env]
    database_config = HashWithIndifferentAccess.new(config)

    client = Mysql2::Client.new(:host => database_config[:host] || "localhost", :username => database_config[:username], :password => database_config[:password], :database => database_config[:database])

    amount = 0

    Blog::Post.find_each do |post|
      result = client.query("select * from seo_meta where seo_meta_id = #{post.old_id} and seo_meta_type = 'Refinery::Page::Translation'", :as => :hash, :symbolize_keys => true).first
      if result.present? && result[:browser_title].present?
        amount += 1
        post.update_attributes(:meta_title => result[:browser_title])
        puts "#{post.title} => #{result[:browser_title]}"
      end
    end

    puts "Insert #{amount} meta_title"
  end

  task :convert_s3_url => :environment do
    Blog::Post.find_each do |post|
      body = Nokogiri::HTML.fragment(post.content)

      body.css('a').each do |link|
        link[:href] = link[:href].gsub("resumecompanionp-staging", "resumecompanionp") if link[:href] && link[:href].match(/resumecompanionp-staging\.s3\.amazonaws\.com/)
      end

      body.css('img').each do |img|
        img[:src] = img[:src].gsub("resumecompanionp-staging", "resumecompanionp") if img[:src] && img[:src].match(/resumecompanionp-staging\.s3\.amazonaws\.com/)
      end

      excerpt = Nokogiri::HTML.fragment(post.excerpt)

      excerpt.css('a').each do |link|
        link[:href] = link[:href].gsub("resumecompanionp-staging", "resumecompanionp") if link[:href] && link[:href].match(/resumecompanionp-staging\.s3\.amazonaws\.com/)
      end

      excerpt.css('img').each do |img|
        img[:src] = img[:src].gsub("resumecompanionp-staging", "resumecompanionp") if img[:src] && img[:src].match(/resumecompanionp-staging\.s3\.amazonaws\.com/)
      end

      post.content = body.inner_html
      post.excerpt = excerpt.inner_html
      post.save
    end
  end

  task :convert_s3_url_to_staging => :environment do
    Blog::Post.find_each do |post|
      body = Nokogiri::HTML.fragment(post.content)

      body.css('a').each do |link|
        link[:href] = link[:href].gsub("resumecompanionp", "resumecompanionp-staging") if link[:href] && link[:href].match(/resumecompanionp\.s3\.amazonaws\.com/)
      end

      body.css('img').each do |img|
        img[:src] = img[:src].gsub("resumecompanionp", "resumecompanionp-staging") if img[:src] && img[:src].match(/resumecompanionp\.s3\.amazonaws\.com/)
      end

      post.content = body.inner_html
      post.save
    end
  end
end
