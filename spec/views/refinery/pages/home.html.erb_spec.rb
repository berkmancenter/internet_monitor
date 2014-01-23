require 'spec_helper'

describe ( 'refinery/pages/home' ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

  subject { rendered }

  context ( 'default view' ) {
    before {
      render
    }

    it {
      should have_css 'div.carousel'
    }
    
    it {
      should have_css 'div.carousel span.carousel-map'
      should have_css 'span.carousel-map #explore-map'
    }

    it {
      should have_css 'div.carousel a[href*="/map"]'
    }

    it {
      should have_css 'h2', text: 'We monitor and score...'
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
      should have_css '.trending h2', text: 'Trending Countries'
    }

    it { 
      should have_css '.trending li .score-pill'
      should have_css ".trending .score-pill[data-country-id='#{country.id}']"
    }
  }
}
