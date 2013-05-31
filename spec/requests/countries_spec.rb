require 'spec_helper'

describe 'countries requests' do
  let ( :country_attr ) { FactoryGirl.attributes_for( :country ) }
  let ( :ds_access ) { FactoryGirl.attributes_for( :ds_access ) }

  before {
    # create all categories
    Category.create!( { name: 'Access' } )
    Category.create!( { name: 'Activity' } )
    Category.create!( { name: 'Control' } )

    Country.create!( country_attr )
  }

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
    let ( :country ) { Country.last }

    before { visit country_url( country ) }

    it {
      should( have_selector( "title", { text: "#{country.name.downcase} @ Internet Monitor" } ) )
    }

    it {
      should( have_selector( "h1 a", { text: "#{country.name} ( #{country.score.round(2)} )" } ) )
    }
  end

  describe( "get /countries/:id/activity" ) do
    let ( :country ) { Country.last }

    before {
      visit activity_url( country )
    }

    it {
      should( have_selector( "title", { text: "#{country.name.downcase} activity @ Internet Monitor" } ) )
    }
  end
end
