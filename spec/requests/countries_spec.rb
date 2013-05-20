require 'spec_helper'

describe "countries requests" do
  let( :testCountry ) { Country.find(108) }
  let( :testCountryActivity ) { CountryCategory.where("country_id = #{testCountry.id} and category_id = 2").first }

  subject { page }

  describe "get /countries" do
    before { visit countries_url }

    it {
      should( have_selector( "title", { text: "countries @ Internet Monitor" } ) )
    }
  end

  describe( "get /countries/:id" ) do
    before { visit country_url( testCountry ) }

    it {
      should( have_selector( "title", { text: "#{testCountry.name.downcase} @ Internet Monitor" } ) )
    }

    it {
      should( have_selector( "h1 a", { text: "#{testCountry.name} ( #{testCountry.score.round(2)} )" } ) )
    }
  end

  describe( "get /countries/:id/activity" ) do
    before { visit activity_url( testCountry ) }

    it {
      should( have_selector( "title", { text: "#{testCountry.name.downcase} activity @ Internet Monitor" } ) )
    }
  end

end
