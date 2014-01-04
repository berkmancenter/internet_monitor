require 'spec_helper'

describe ( 'countries/show' ) {
  subject { rendered }

  context ( 'normal country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :update ) { strip_tags( Refinery::Page.by_slug( country.iso3_code.downcase ).first.content_for( :body ) ) }

    before {
      assign( :map_countries, Country.with_enough_data.where( { id: country.id } ).select( 'iso3_code,score' ) )
      assign( :country, country )
      assign( :update, update )
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
      should have_css '.update', text: update
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

  context ( 'with country having not enough indicators' ) {
    let ( :country ) { Country.find_by_iso3_code( 'USA' ) }

    before {
      assign( :map_countries, Country.with_enough_data.where( { id: country.id } ).select( 'iso3_code,score' ) )
      assign( :country, country )
      render
    }

    it {
      should have_css '.view h1', text: country.name
    }

    it {
      should have_css 'h1 .score-pill'
      should_not have_css 'h1 .score-pill .imon-score'
    }

  }
}
