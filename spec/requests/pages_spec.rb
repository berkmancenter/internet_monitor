require 'spec_helper'

# refinery pages
describe ( 'pages requests' ) {
  subject { page }

  describe ( 'get /home' ) {
    before { visit refinery::root_path }

    it {
      should have_title 'Home | Internet Monitor'
    }
  }

  describe ( 'get /about' ) {
    before { visit refinery::marketable_page_path('about') }

    it {
      should have_title 'About | Internet Monitor'
    }

    it {
      should have_css 'h1', text: 'About'
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
}
