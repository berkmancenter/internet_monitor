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
      should have_css ".score-pill[data-country-id='#{country.id}']"
    }

    it {
      should have_css "a[href*='#{category_country_path country, category_slug: 'access'}'].country-name", text: country.name
      should have_css "a[title='#{country.name}']"
    }

    it {
      should have_css 'span.header', text: 'score'
    }

    it {
      should have_css 'span.imon-rank', text: '2'
    }

    it {
      should have_css 'span.imon-score', text: country.score.round(2), exact: true
    }

    it {
      should have_css 'a.user-score'
    }

    it {
      should have_css 'a.user-rank'
    }
  }
}
