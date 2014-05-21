require 'spec_helper'

describe ( 'countries/show' ) {
  subject { rendered }

  context ( 'normal country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :update ) { Refinery::Page.by_slug( country.iso3_code.downcase ).first.content_for( :body ) }

    before {
      assign( :map_countries, Country.with_enough_data.where( { id: country.id } ).select( 'iso3_code,score' ) )
      assign( :country, country )
      render
    }

    it {
      should have_css '.view.country-data-view'
    }

    describe ( 'header text' ) {
      it {
        should have_css '.view h1', text: country.name
      }

      it {
        should have_css '.view h1.head-banner'
      }
    }

    it {
      should_not have_css 'h1 .score-pill'
    }

    it ( 'should have category selector' ) {
      # moved from layout
      should have_css '.category-selector'
      should have_css '.category-selector.expanded'
    }

    it ( 'h1 has country name score (inside pill)' ) {
      should have_css 'h1', text: country.name
      should_not have_css 'h1', text: country.score.round(2), exact: true
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
      should have_css '.update', text: strip_tags( update )
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

    context ( 'formatted sidebar data' ) {
      it ( 'Population' ) {
        should have_css '.sidebar dt', text: 'Population'
        should have_css '.sidebar dd', text: '74,798,599'
      }

      it ( 'GDP' ) {
        should have_css '.sidebar dt', text: 'GDP'
        should have_css '.sidebar dd', text: '$4,526'
      }
    }
  }

  context ( 'without update' ) {
    let ( :country ) { Country.find_by_iso3_code( 'CHN' ) }
    let ( :update ) { Refinery::Page.by_slug( 'zzz-countries' ).first.content_for( :body ) }

    before {
      assign( :map_countries, Country.with_enough_data.where( { id: country.id } ).select( 'iso3_code,score' ) )
      assign( :country, country )
      render
    }

    it ( 'should have the generic country update' ) {
      should have_css '.update', text: strip_tags( update )
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
      should_not have_css 'h1 .score-pill'
      should_not have_css 'h1 .score-pill .imon-score'
    }

  }
}
