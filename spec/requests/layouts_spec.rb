require 'spec_helper'

# simple tests for basic layout elements
describe 'layout requests' do
  subject { page }

  describe ( 'get /' ) {
    before { visit refinery::root_path }

    describe ( 'header nav' ) {
      it {
        should have_selector( 'header nav' );

        should have_selector( "header a[href*='#{refinery::marketable_page_path('about')}']" );
        should have_selector( "header a[href*='#{map_path}']" );
        should have_selector( "header a[href*='#{countries_path}']" );
        should have_selector( "header a[href*='#{refinery::blog_root_path}']" );
      }
    }

    describe ( 'footer nav' ) {
      it {
        should have_selector( 'footer nav' );

        should have_selector( "footer a[href*='#{refinery::marketable_page_path('about')}']" );
        should have_selector( "footer a[href*='#{refinery::blog_root_path}']" );
      }
    }
  }
end
