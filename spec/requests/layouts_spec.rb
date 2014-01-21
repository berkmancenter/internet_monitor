require 'spec_helper'

# simple interaction tests for application layout elements
describe 'layout requests', :js => true do
  subject { page }

  describe ( 'get /' ) {
    before { visit refinery::root_path }

    describe ( 'click countries' ) {
      before {
        click_link 'countries'
        sleep 1
      }

      it {
        should have_css '.countries-nav-list.expanded'
      }

      it {
        # countries without enough data should not show in this list
        should_not have_css '.countries-nav-list a', text: 'UNITED STATES'
      }

      describe ( 'click countries twice' ) {
        before {
          click_link 'countries'
        }

        it ( 'should hide country list' ) {
          should_not have_css '.countries-nav-list.expanded'
        }
      }
    }

    describe ( 'click categories' ) {
      it {
        click_link 'categories'
        should have_css '.category-selector.expanded'
      }
    }

    describe ( 'click categories twice' ) {
      it ( 'should hide country list' ) {
        click_link 'categories'
        click_link 'categories'
        should_not have_css '.category-selector.expanded'
      }
    }

    context ( 'with countries expended, click categories' ) {
      it ( 'should close countries' ) {
        click_link 'countries'
        click_link 'categories'
        should_not have_css '.countries-nav-list.expanded'
        should have_css '.category-selector.expanded'
      }
    }
  }
end
