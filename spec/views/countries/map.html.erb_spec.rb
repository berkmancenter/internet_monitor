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
      should have_css 'script#popup-tmpl', visible: false

      # info shown in the popup
      should have_css '#popup-tmpl', text: 'name', visible: false
      should have_css '#popup-tmpl', text: 'score', visible: false
      should have_css '#popup-tmpl', text: '/countries/', visible: false
    }

    it {
      should have_css '.map-index'
    }

    it {
      should have_css '.map-index h2', text: 'Countries', exact: true
      should have_css '.map-index ol.scored-countries' #ordered
    }

    it {
      should_not have_css '.map-index h2', text: 'Countries Without Scores'
      should_not have_css '.map-index ul.unscored-countries' #unordered
    }

    it {
      should have_css '.map-index ol .score-pill'
      should_not have_css '.map-index ul .score-pill'
    }
  }
}
