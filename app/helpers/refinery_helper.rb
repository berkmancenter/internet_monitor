module RefineryHelper
  # return content based on page slug & part name
  def part_content( slug, part_name )
    page = Refinery::Page.by_slug slug
    content = page.first.content_for( part_name ) unless page.empty?
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

  def home_carousel
    carousel = Refinery::Page.by_slug 'carousel'
    if carousel.any?
      carousel.first.children.map { |page|
        {
          link_url: page.link_url,
          body: page.content_for( :body )
        }
      }
    else
      [ ]
    end
  end
end
