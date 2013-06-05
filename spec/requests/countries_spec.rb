require 'spec_helper'

describe 'countries requests' do
  subject { page }

  describe 'get /countries' do
    before {
      visit( countries_url )
    }

    it {
      should( have_selector( "title", { text: "countries @ Internet Monitor" } ) )
    }
  end

  describe( "get /countries/:id" ) do
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before { visit country_url( country ) }

    it {
      should( have_selector( "title", { text: "#{country.name.downcase} @ Internet Monitor" } ) )
    }

    it {
      should( have_selector( "h1 a", { text: "#{country.name} ( #{country.score.round(2)} )" } ) )
    }
  end

  describe( "get /countries/:id/activity" ) do
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before {
      visit activity_url( country )
    }

    it {
      should( have_selector( "title", { text: "#{country.name.downcase} activity @ Internet Monitor" } ) )
    }
  end
end
