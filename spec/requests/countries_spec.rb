require 'spec_helper'

describe 'countries requests', :js => true do
  let ( :indicator_count ) { DatumSource.where( { affects_score: true } ).count }
  subject { page }

  shared_examples_for( 'weight_slider' ) {
    it ( 'should have country data loading screen' ) {
      should have_css '.score-keeper-loader', visible: false
    }

    it ( 'should have a score pill for our test country' ) {
      should have_css ".score-pill[data-country-id='#{country.id}']"
    }

    it ( 'should have weight_slider link' ) {
      should have_selector( 'a.toggle-weight-sliders' );
      should have_css '#weight-sliders.hidden', visible: false
    }

    describe ( 'click toggle-weight-sliders' ) {
      before {
        page.execute_script( %q[$('.toggle-weight-sliders').click( )] );
      }

      it ( 'should show weight-sliders' ) {
        find( '#weight-sliders' ).visible?.should be_true
        should have_css '#weight-sliders .weight-slider', count: indicator_count
      }

      it ( 'should hide weight-sliders' ) {
        page.execute_script( %q[$('.toggle-weight-sliders').click( )] );
        should have_css '#weight-sliders', count: 0
      }
    }
  }

  describe ( 'get /countries index' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :country_no_score ) { Country.find_by_iso3_code( 'USA' ) }

    before {
      visit( countries_path )
    }

    it {
      should have_title 'Countries | Internet Monitor'
    }

    it_should_behave_like( 'weight_slider' );

    # full tests for weight slider/scoreKeeper on countries page with multiple score pills

    describe( 'scoreKeeper' ) {
      context ( 'without user score' ) {
        it {
          should_not have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
        }
      }

      context ( 'with sliding a slider' ) {
        before {
          page.execute_script( %q[$('.toggle-weight-sliders').click( )] )
          page.execute_script( %q[$('[name="ds_pct_inet"]').val( 0.5 ).trigger('input')] )
          sleep 1
        }

        it {
          current_url.should match 'ds_pct_inet=0.5'
        }

        it {
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '3.34'
        }

        it ( 'should not updated score pills for countries without enough data' ) {
          should_not have_css ".score-pill[data-country-id='#{country_no_score.id}'] .user-score.updated"
        }

        describe ( 'refresh' ) {
          before {
            visit current_url
          }

          it ( 'should maintain state' ) {
            should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
            should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '3.34'
          }
        }
      }

      context ( 'with negative default weight' ) {
        before {
          page.execute_script( %q[$('.toggle-weight-sliders').click( )] )
        }

        it {
          slider_val = page.evaluate_script %q[$('[name="ds_fixed_monthly"]').val( )]
          slider_val.should eq( '1' )
        }
      }
    }
  }

  context ( 'with scoreKeeper state in url' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    context ( 'with user weight' ) {
      before {
        visit "#{countries_path}#ds_pct_inet=1.5"
        page.execute_script %q[$('.toggle-weight-sliders').click( )]
      }

      it {
        should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
        should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '3.89'
      }

      it {
        slider_val = page.evaluate_script %q[$('[name="ds_pct_inet"]').val( )]
        slider_val.should eq( '1.5' )
      }

      describe ( 'move to another page' ) {
        before {
          visit country_path( country )
        }

        it ( 'should maintain state' ) {
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '3.89'
        }
      }
    }

    context ( 'with default weight' ) {
      before {
        visit "#{countries_path}#ds_pct_inet=1"
      }

      it {
        should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
        should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: country.score.round( 2 )
      }

    }
  }

  shared_examples_for( 'category_selector' ) {
    it ( 'should have category selector links' ) {
      should have_selector( ".category-selector a[href*='#{category_country_path(country, :category_slug => "access")}']" );
      should have_selector( ".category-selector a[href*='#{category_country_path(country, :category_slug => "control")}']" );
      should have_selector( ".category-selector a[href*='#{category_country_path(country, :category_slug => "activity")}']" );
    }
  }

  describe ( 'get /countries/:id' ) {
    context ( 'with normal country' ) {
      let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

      before { visit country_path( country ) }

      it {
        should have_title "#{country.name.titleize} | Internet Monitor"
      }

      it {
        should have_selector 'h1', text: country.name
      }

      it_should_behave_like( 'weight_slider' );

      it_should_behave_like( 'category_selector' );
      it ( 'should not have any category' ) {
        should_not have_selector '.category-selector a.selected' 
      }

      it ( 'should not have indicators' ) {
        should_not have_selector '.country .indicators,.country .url-lists,.country .html-blocks,.country .images'
      }

      it {
        should have_css '.score-pill'
      }

      it ( 'should have a map' ) {
        should have_css '.sidebar .geomap'
      }

      it ( 'map should be static' ) {
        mode = page.evaluate_script( %q[$('.sidebar .geomap').geomap('option', 'mode')] )
        mode.should eq( 'static' )
      }

      it ( 'map only needs to color target country' ) {
        map_countries_count = page.evaluate_script( %q[$('.sidebar .geomap').data('mapCountries').length] )
        map_countries_count.should eq( 1 )
      }

      describe ( 'click user score in pill' ) {
        before {
          page.execute_script( %q[$('a.user-score').click( )] );
          #click_link 'a.user-score'
        }

        it {
          find( '#weight-sliders' ).visible?.should be_true;
        }
      }
    }
  }

  describe( "get /countries/:id/access" ) do
    context ( 'with normal country' ) {
      let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
      let ( :category ) { Category.find_by_name( 'Access' ) }

      before {
        visit category_country_path(country, :category_slug => 'access')
      }

      it {
        should have_title( "#{country.name.titleize} Access | Internet Monitor" )
      }

      it_should_behave_like( 'weight_slider' );

      it_should_behave_like( 'category_selector' );
      it ( 'should have category selected' ) {
        should have_selector( ".category-selector a[href*='#{category_country_path(country, :category_slug => "access")}'].selected" );
      }
    }

    context ( 'with country missing access CMS page' ) {
      let ( :country ) { Country.find_by_iso3_code( 'USA' ) }
      let ( :category ) { Category.find_by_name( 'Access' ) }

      before {
        visit category_country_path( country, category_slug: 'access' )
      }

      it {
        should have_title( "#{country.name.titleize} Access | Internet Monitor" )
      }
    }
  end

  describe 'get /countries/:id/control' do
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :category ) { Category.find_by_name( 'Control' ) }

    before {
      visit category_country_path( country, :category_slug => 'control' )
    }

    it {
      should have_title( "#{country.name.titleize} Control | Internet Monitor" )
    }

    it_should_behave_like( 'weight_slider' );

    it_should_behave_like( 'category_selector' );
    it ( 'should have category selected' ) {
      should have_selector( ".category-selector a[href*='#{category_country_path(country, :category_slug => "control")}'].selected" );
    }
  end

  describe( "get /countries/:id/activity" ) do
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :category ) { Category.find_by_name( 'Activity' ) }

    before {
      visit category_country_path( country, :category_slug => 'activity' )
    }

    it {
      should have_title( "#{country.name.titleize} Activity | Internet Monitor" )
    }

    it_should_behave_like( 'weight_slider' );

    it_should_behave_like( 'category_selector' );
    it ( 'should have category selected' ) {
      should have_selector( ".category-selector a[href*='#{category_country_path(country, :category_slug => "activity")}'].selected" );
    }
  end

end
