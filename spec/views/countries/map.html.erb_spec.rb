require 'spec_helper'

describe ( 'countries/map' ) {
  subject { rendered }

  let ( :scored_countries ) { Country.with_enough_data }
  let ( :max_score )  { scored_countries.order('score desc').first.score }

  context ( 'default view' ) {
    before {
      assign( :scored_countries, scored_countries )
      assign( :map_countries, scored_countries )
      assign( :unscored_countries, Country.without_enough_data )
    
      render
    }

    it {
      should have_css '.geomap'
      should have_css ".geomap[data-max-score='#{max_score}']"
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
