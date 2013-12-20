require 'spec_helper'

describe ( 'refinery/pages/home' ) {
  subject { rendered }

  context ( 'default view' ) {
    before {
      render
    }

    it {
      should have_css 'div.carousel'
    }
    
    it {
      should have_css 'div.carousel div.carousel-map'
      should have_css 'span.carousel-map #explore-map'
    }

    it {
      should have_css 'div.carousel a[href*="/map"]'
    }

    it {
      should have_css 'h2', text: 'We monitor and score...'
    }

    it {
      should have_css 'li.category-block a[href*="/access"]'
      should have_css 'li.category-block a[href*="/control"]'
      should have_css 'li.category-block a[href*="/activity"]'
    }

    it {
      should have_css 'li.category-block h3', text: 'access'
      should have_css 'li.category-block h3', text: 'control'
      should have_css 'li.category-block h3', text: 'activity'
    }

    it {
      should have_css 'li.category-block p', count: 3
    }
  }
}
