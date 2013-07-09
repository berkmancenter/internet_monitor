require 'spec_helper'

describe 'countries requests' do
  subject { page }

  shared_examples_for( 'weight_slider' ) {
    it ( 'should have weight_slider link' ) {
      should have_selector( 'a.toggle-weight-sliders' );
      should have_selector( '#weight-sliders.hidden' );
    }
  }

  describe 'get /countries' do
    before {
      visit( countries_url )
    }

    it {
      should have_title( 'countries @ Internet Monitor' )
    }

    it_should_behave_like( 'weight_slider' );
  end

  shared_examples_for( 'category_selector' ) {
    it ( 'should have category selector links' ) {
      should have_selector( ".category-selector a[href*='#{access_path( country )}']" );
      should have_selector( ".category-selector a[href*='#{control_path( country )}']" );
      should have_selector( ".category-selector a[href*='#{activity_path( country )}']" );
    }
  }


  describe( "get /countries/:id" ) do
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before { visit country_url( country ) }

    it {
      should have_title( "#{country.name.downcase} @ Internet Monitor" )
    }

    it {
      should have_selector( "h1 a", { text: "#{country.name} #{country.score.round(2)}" } )
    }

    it_should_behave_like( 'category_selector' );
    it ( 'should not have any category' ) {
      should_not have_selector( ".category-selector a.selected" );
    }

    it ( 'should not have indicators' ) {
      should_not have_selector( '.indicators,.url-lists,.html-blocks,.images' );
    }
  end

  describe( "get /countries/:id/access" ) do
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :category ) { Category.find_by_name( 'Access' ) }

    before {
      visit access_url( country )
    }

    it {
      should have_title( "#{country.name.downcase} access @ Internet Monitor" )
    }

    it_should_behave_like( 'category_selector' );
    it ( 'should have category selected' ) {
      should have_selector( ".category-selector a[href*='#{access_path( country )}'].selected" );
    }

    it {
      should_not have_selector( 'h1', { text: 'Access' } );
    }
  end

  describe( "get /countries/:id/control" ) do
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :category ) { Category.find_by_name( 'Control' ) }

    before {
      visit control_url( country )
    }

    it {
      should have_title( "#{country.name.downcase} control @ Internet Monitor" )
    }

    it_should_behave_like( 'category_selector' );
    it ( 'should have category selected' ) {
      should have_selector( ".category-selector a[href*='#{control_path( country )}'].selected" );
    }

    it {
      should_not have_selector( 'h1', { text: 'Control' } );
    }
  end

  describe( "get /countries/:id/activity" ) do
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :category ) { Category.find_by_name( 'Activity' ) }

    before {
      visit activity_url( country )
    }

    it {
      should have_title( "#{country.name.downcase} activity @ Internet Monitor" )
    }

    it_should_behave_like( 'category_selector' );
    it ( 'should have category selected' ) {
      should have_selector( ".category-selector a[href*='#{activity_path( country )}'].selected" );
    }

    it {
      should_not have_selector( 'h1', { text: 'Activity' } );
    }
  end
end
