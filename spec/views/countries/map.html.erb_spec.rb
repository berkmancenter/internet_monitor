require 'spec_helper'

describe ( 'countries/map' ) {
  subject { rendered }

  context ( 'default view' ) {
    before {
      assign( :map_countries, Country.with_enough_data.select( 'iso3_code,score' ) )
      assign( :scored_countries, Country.with_enough_data )
      assign( :unscored_countries, Country.without_enough_data )
    
      render
    }

    it {
      should have_css '.geomap'
      should have_css '.geomap[data-max-score="4.82843928"]'
    }

    it {
      should have_css '.map-index'

      should have_css '.map-index h2', text: 'Countries', exact: true
      should have_css '.map-index ol.scored-countries' #ordered

      should have_css '.map-index h2', text: 'Countries Without Scores'
      should have_css '.map-index ul.unscored-countries' #unordered
    }

    it {
      should have_css '.map-index ol .score-pill'
      should have_css '.map-index ul .score-pill'
    }
  }
}
