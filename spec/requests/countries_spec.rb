require 'spec_helper'

describe "countries requests" do
  let( :testCountry ) { Country.find(108) }
  let( :testActivity ) { CountryCategory.where("country_id = #{testCountry.id} and category_id = 2").first }

  subject { page }

  describe "get /countries" do
    before { visit countries_path }

    it {
      should( have_selector( "title", { text: "countries @ Internet Monitor" } ) )
    }
  end

  describe( "get /countries/:id" ) do
    before { visit country_path( testCountry ) }

    it {
      should( have_selector( "title", { text: "#{testCountry.name.downcase} @ Internet Monitor" } ) )
    }

    it {
      should( have_selector( "h1 a", { text: "#{testCountry.name} ( #{testCountry.score.round(2)} )" } ) )
    }
  end

#  describe( "get /country_categories/:id" ) do
#    before { visit country_category( testActivity ) }
#
#    it {
#      should( have_selector( "title", { text: "#{testCountry.name.downcase}  @ Internet Monitor" } ) )
#    }
#
#  end

  #describe( "get /countries/:id/activity" ) do
    # /countries/:id/activity should route to country_categories/:id for country=id & category=2
  #end

end
