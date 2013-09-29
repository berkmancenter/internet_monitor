require 'spec_helper'

describe ( 'country_categories/show' ) {
  subject { rendered }

  context ( 'normal country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before {
      assign( :country, country )
    }

    context ( 'access' ) {
      let ( :category ) { Category.find_by_slug( 'access' ) }

      before {
        assign( :category, category )
        render
      }

      it {
        should have_css '.view.country-data-view'
      }

      it {
        should have_css '.view h1', text: country.name
        should have_css '.view h1', text: category.name
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

      it ( 'should not have a country update block' ) {
        should_not have_css '.main-column .update.block'
      }

      it ( 'should have a country sidebar' ) {
        should have_css '.sidebar-column .sidebar.block'
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

    context ( 'control' ) {
      let ( :category ) { Category.find_by_slug( 'control' ) }

      before {
        assign( :category, category )
        render
      }

      it {
        should have_selector 'h1', text: country.name
        should have_selector 'h1', text: category.name
      }
    }

    context ( 'activity' ) {
      let ( :category ) { Category.find_by_slug( 'activity' ) }

      before {
        assign( :category, category )
        render
      }

      it {
        should have_selector 'h1', text: country.name
        should have_selector 'h1', text: category.name
      }
    }
  }
}
