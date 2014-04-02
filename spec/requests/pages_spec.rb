require 'spec_helper'

# refinery pages
describe ( 'pages requests' ) {
  subject { page }

  describe 'get /home', :js => true do
    before { visit refinery::root_path }

    it {
      should have_title 'Home | Internet Monitor'
    }

    it ( 'should have FilmRoll' ) {
      should have_css '.carousel .film_roll_wrapper'
    }
  end

  describe ( 'get /about' ) {
    before { visit refinery::marketable_page_path('about') }

    it {
      should have_title 'About | Internet Monitor'
    }

    it {
      should have_css 'h1', text: 'About'
    }

    it {
      should have_css 'body.refinery-pages'
    }

    it {
      should have_css '.refinery-pages #body_content'
    }

    it {
      should have_css '#body_content #body_content_title'
    }

    it {
      should have_css 'section#body'
    }

    it {
      should have_css 'section#side_body'
    }
  }

  describe ( 'get /sources' ) {
    before { visit refinery::marketable_page_path('sources') }

    it {
      should have_css 'h1', text: 'Data'
    }

    it {
      should have_css 'section#body'
    }

    it {
      should have_css 'section#side_body'
    }
  }

  context ( 'from user weight' ) {
    let ( :country ) { Country.find_by_iso3_code( 'CHN' ) }

    let ( :category ) { Category.find_by_name( 'Access' ) }

    before {
      visit "#{category_country_path(country, :category_slug => 'access')}#adoption=1.5"
    }

    describe ( 'move to page' ) {
      before { visit refinery::marketable_page_path('about') }

      it {
        current_url.should_not match 'adoption'
      }
    }
  }
}
