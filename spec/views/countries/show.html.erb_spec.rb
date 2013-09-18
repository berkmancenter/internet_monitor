require 'spec_helper'

describe ( 'countries/show' ) {
  subject { rendered }

  context ( 'normal country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before {
      assign( :country, country )
      render
    }

    it {
      should have_css '.view h1'
    }

    it ( 'h1 no longer has score' ) {
      should have_css 'h1', text: country.name
      should_not have_css 'h1', text: country.score
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

    it ( 'no more country dropdown in sidebar' ) {
      should_not have_css '.sub-content .country-data'
    }

    it ( 'should not have generic indicators' ) {
      should_not have_css '.sidebar .indicators'
    }

    it ( 'should have sidebar data' ) {
      should have_css '.sidebar dt', text: 'Population'
    }
  }
}
