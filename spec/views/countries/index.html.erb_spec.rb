require 'spec_helper'

describe ( 'countries/index' ) {
  subject { rendered }

  context ( 'default view' ) {
    before {
      assign( :scored_countries, Country.with_enough_data )
      assign( :unscored_countries, Country.without_enough_data )
    
      render
    }

    it {
      should have_css 'h2', text: 'Countries', exact: true
      should have_css 'ol.scored-countries' #ordered
    }

    it {
      should_not have_css 'h2', text: 'Countries Without Scores'
      should_not have_css 'ul.unscored-countries' #unordered
    }

    it {
      should have_css 'ol .score-pill'
      should_not have_css 'ul .score-pill'
    }
  }
}
