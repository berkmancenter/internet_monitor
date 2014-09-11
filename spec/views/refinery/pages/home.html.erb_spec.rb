require 'spec_helper'

describe ( 'refinery/pages/home' ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

  subject { rendered }

  context ( 'default view' ) {
    before {
      assign( :map_countries, Country.with_enough_data.where( { id: country.id } ).select( 'iso3_code,score' ) )
      render
    }

    it {
      should_not have_css '.category-selector'
    }

    it ( 'should have tagline' ) {
      # now in header image
      should_not have_css 'p.tagline', text: 'Analyzing'
    }

    describe ( 'carousel' ) {
      it {
        should have_css 'div.carousel'
      }
      
      it {
        should have_css 'div.carousel > div a[href*="/about"]'
      }

      it {
        should have_css 'div.carousel > div a[href*="/map"]'
      }
    }

    it {
      should have_css 'h2', text: 'We monitor and report on...'
    }

    it {
      should have_css 'li.category-block a[href*="/access"]'
      should have_css 'li.category-block h3', text: 'access'
      should have_css 'p', text: 'Who has Internet access'
    }

    it {
      should have_css 'li.category-block a[href*="/control"]'
      should have_css 'li.category-block h3', text: 'control'
    }

    it {
      should have_css 'li.category-block a[href*="/activity"]'
      should have_css 'li.category-block h3', text: 'activity'
    }

    it {
      should have_css 'li.category-block span', count: 3
    }

    it {
      should have_css 'section.twitter'
      should have_css 'section.twitter h1', text: 'Latest Tweets from'
    }

    it {
      should have_css '.twitter ul.tweets'
      should have_css 'ul.tweets li', count: 3
    }

    it {
      should have_css '.twitter span', text: 'on Twitter'
    }

    describe ( 'trending' ) {
      it {
        should have_css '.trending h2', text: 'Featured Countries'
      }

      it { 
        should have_css ".trending li a[data-country-id='#{country.id}']"
      }

      it ( 'should no longer have score pills' ) { 
        # score pills removed from home
        should_not have_css '.trending li .score-pill'
        should_not have_css ".trending .score-pill[data-country-id='#{country.id}']"
      }

      it {
        should_not have_css '.trending li .score-pill .user-score'
        should_not have_css '.trending li .score-pill .user-rank'
      }

      it ( 'should no longer have map data at top level' ) {
        should_not have_css '.trending[data-map-countries]'
        should_not have_css '.trending[data-min-score]'
        should_not have_css '.trending[data-max-score]'
      }

      it ( 'should map of country' ) {
        should have_css '.trending li a .trending-map'
        should_not have_css '.trending li a .trending-map[data-country-iso3="IRN"]'
      }

      it ( 'should have png thumb of country' ) {
        should have_css '.trending li a .trending-map img'
        should have_css ".trending li a .trending-map img[src*='#{thumb_country_path country}']"
      }

      it ( 'map should show country name' ) {
        should have_css '.trending li a .trending-map span', text: country.name
      }
    }
  }
}
