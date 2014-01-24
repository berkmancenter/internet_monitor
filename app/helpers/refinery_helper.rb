module RefineryHelper
  # return content based on page slug & part name
  def part_content( slug, part_name )
    page = Refinery::Page.by_slug slug
    content = page.first.content_for( part_name ) unless page.empty?
  end

  # return last five tweets
  def imon_tweets
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Imon::Application.config.imon['twitter_consumer_key']
      config.consumer_secret     = Imon::Application.config.imon['twitter_consumer_secret']
      config.access_token        = Imon::Application.config.imon['twitter_access_token']
      config.access_token_secret = Imon::Application.config.imon['twitter_access_token_secret']
    end

    silence_warnings do
      client.user_timeline 'thenetmonitor', count: 7
    end
  end

  def home_carousel
    carousel = Refinery::Page.by_slug 'carousel'
    if carousel.any?
      Refinery::Page.where( { parent_id: carousel.first.id } ).reverse_each.map { |page|
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
