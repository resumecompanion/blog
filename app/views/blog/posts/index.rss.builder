xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @title
    xml.description "#{@title} - Post List"
    xml.link blog.root_url
    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.excerpt
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.author post.author.nickname
        xml.link blog.post_url(post)
        xml.guid blog.post_url(post)
      end
    end
  end
end
