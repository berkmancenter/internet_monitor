require 'spec_helper'

describe "countries requests" do
  let( :iran ) { Country.find(108) }

  subject { page }

  describe "get /countries" do
    before { visit countries_path }

    it {
      should( have_selector( "title", { text: "countries @ Internet Monitor" } ) )
    }
  end

  describe( "get /countries/:id" ) do
    before { visit country_path( iran ) }

    it {
      should( have_selector( "title", { text: "iran @ Internet Monitor" } ) )
    }

    it {
      should( have_selector( "h1 a", { text: "#{iran.name} ( #{iran.score.round(2)} )" } ) )
    }
  end

end
