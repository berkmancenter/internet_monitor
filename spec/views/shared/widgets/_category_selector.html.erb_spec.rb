require 'spec_helper'

describe ( 'shared/widgets/_category_selector' ) {
  subject { rendered }

  context ( 'no country' ) {
    before {
      render
    }

    it {
      should have_css '.category-selector'
    }

    it {
      should_not have_css 'li:first a', text: 'Overview'
    }

    it {
      should have_css 'li:first a', text: 'Access'
    }

    it {
      should have_css 'li:nth-child(2) a', text: 'Control'
    }

    it {
      should have_css 'li:last a', text: 'Activity'
    }
  }

  context ( 'country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before {
      assign( :country, country )
      render
    }

    it {
      should have_css '.category-selector'
    }

    it {
      should have_css 'li:first a', text: 'Overview'
    }

    it {
      should have_css 'li:nth-child(2) a', text: 'Access'
    }

    it {
      should have_css 'li:nth-child(3) a', text: 'Control'
    }

    it {
      should have_css 'li:last a', text: 'Activity'
    }
  }
}
