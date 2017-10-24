module RefineryHelper
  # return content based on page slug & part name
  def part_content( slug, part_name )
    page = Refinery::Page.by_slug slug
    content = page.first.content_for( part_name ) unless page.empty?
  end

  def sibling_pages
    # return the slugs of all sibling of the current page in refinery, including this one
    @page.parent.children.pluck( :slug )
  end

  # return last 3 blog posts 
  def recent_posts
    posts = Refinery::Blog::Post.order("published_at DESC").first(3)
  end

  def post_author( post )
    if post.present? && post.author.present?
      (post.author.full_name.nil? || post.author.full_name.empty?) ? post.author.username : post.author.full_name
    else
      'Unknown'
    end
  end

  # return last three tweets
  def imon_tweets
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Imon::Application.config.imon['twitter_consumer_key']
      config.consumer_secret     = Imon::Application.config.imon['twitter_consumer_secret']
      config.access_token        = Imon::Application.config.imon['twitter_access_token']
      config.access_token_secret = Imon::Application.config.imon['twitter_access_token_secret']
    end

    begin
      silence_warnings do
        client.user_timeline 'thenetmonitor', count: 3
      end
    rescue Twitter::Error => e
      [ Twitter::Tweet.new( { id: 1, text: '' } ) ]
    end
  end
  
end
