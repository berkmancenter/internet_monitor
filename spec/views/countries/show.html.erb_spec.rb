require 'spec_helper'

describe ( 'countries/show' ) {
  subject { rendered }

  context ( 'normal country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before {
      assign( :map_countries, Country.with_enough_data.select( 'iso3_code,score' ) )
      assign( :country, country )
      assign( :update, Refinery::Page.by_slug( country.iso3_code.downcase ).first.content_for( :body ) )
      render
    }

    it {
      should have_css '.view.country-data-view'
    }

    it {
      should have_css '.view h1', text: country.name
    }

    it {
      should have_css 'h1 .score-pill'
    }

    it ( 'h1 has country name score (inside pill)' ) {
      should have_css 'h1', text: country.name
      should have_css 'h1', text: country.score.round(2), exact: true
    }

    it ( 'h1 & .sub-content are siblings' ) {
      should have_css 'h1~.sub-content'
    }

    it ( 'should have main & sidebar columns' ) {
      should have_css '.sub-content .main-column'
      should have_css '.sub-content .sidebar-column'
    }

    it ( 'should have at least a country update & sidebar' ) {
      should have_css '.main-column .update.block'
      should have_css '.sidebar-column .sidebar.block'
    }

    it ( 'should pull the update text from a refinery page' ) {
      should have_css '.update', text: 'Iran, also formerly known as Persia, and officially the Islamic Republic of Iran since 1980, is a country in Western Asia.'
    }

    it ( 'should have a map' ) {
      should have_css '.sidebar .geomap'
      should have_css '.sidebar .geomap[data-max-score]'
      should have_css '.sidebar .geomap[data-max-score][data-country-iso3="IRN"]'
    }

    it ( 'no more country dropdown in sidebar' ) {
      should_not have_css '.sub-content .country-data'
    }

    it ( 'should not have generic indicators in sidebar' ) {
      should_not have_css '.sidebar .indicators'
    }

    it ( 'should have sidebar data' ) {
      should have_css '.sidebar dt', text: 'Population'
    }
  }
}
