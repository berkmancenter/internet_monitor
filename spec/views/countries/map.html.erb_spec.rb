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
    }

    it {
      should have_css '.map-index'
      should have_css '.map-index ol.scored-countries'
      should have_css '.map-index ol.unscored-countries'
    }

    it {
      should have_css '.map-index .score-pill'
    }
  }
}
