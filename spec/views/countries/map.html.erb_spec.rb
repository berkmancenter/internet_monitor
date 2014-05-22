require 'spec_helper'

describe ( 'countries/map' ) {
  subject { rendered }

  let ( :scored_countries ) { Country.with_enough_data }
  let ( :min_score )  { scored_countries.order('score').first.score }
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
      should have_css ".geomap[data-min-score='#{min_score}']"
      should have_css ".geomap[data-max-score='#{max_score}']"
    }

    it ( 'should have zoom buttons' ) {
      should have_css '.zoom-in'
      should have_css '.zoom-out'
    }

    it ( 'should have legend' ) {
      # just a placeholder, values are added on calculation
      should have_css '.map-legend', visible: false
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
      should have_css '.map-index .map-pills-container'
    }

    it ( 'should have headers' ) {
      should have_css '.map-index h2 span', text: 'country'
      should have_css '.map-index h2 span', text: "rank (of #{scored_countries.count})"
      should have_css '.map-index h2 span', text: 'score (of 10)'
      should have_css '.map-index h2 span', text: 'user score'
      should have_css '.map-index h2 span', text: 'user rank'
    }

    it {
      should_not have_css '.map-index h2', text: 'Country Scores', exact: true
      should have_css '.map-index ol.scored-countries' #ordered
    }

    it {
      # removed
      should_not have_css '.map-index h2', text: 'Countries Without Scores'
      should_not have_css '.map-index ul.unscored-countries' #unordered
    }

    it {
      should have_css '.map-index ol .score-pill'
      should_not have_css '.map-index ul .score-pill'
    }

  }
}
