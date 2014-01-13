require 'spec_helper'

describe ( 'shared/widgets/_category_selector' ) {
  subject { rendered }

  context ( 'normal selector' ) {
    before {
      render
    }

    it {
      should have_css '.category-selector'
    }

    it {
      should have_css 'li:first a', text: 'Access'
    }

    it {
      should have_css 'li:last a', text: 'Activity'
    }
  }
}
