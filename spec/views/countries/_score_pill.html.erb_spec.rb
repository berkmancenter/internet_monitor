require 'spec_helper'

describe ( 'countries/_score_pill' ) {
  subject { rendered }

  context ( 'normal country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before {
      assign( :country, country )
      render 'countries/score_pill', country: country
    }

    it {
      should have_css '.score-pill'
    }

    it {
      should have_css 'span', text: 'score'
    }
  }
}
