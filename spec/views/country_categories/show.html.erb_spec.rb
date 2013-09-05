require 'spec_helper'

describe ( 'country_categories/show' ) {
  subject { rendered }

  context ( 'normal country: access' ) {
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
        should have_selector 'h1', text: country.name
        should have_selector 'h1', text: category.name
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
