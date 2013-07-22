require 'spec_helper'

describe ( 'map requests' ) {
  subject { page }

  describe 'get /map', :js => true do
    before { visit map_path }

    # map
    it {
      should have_selector( 'section.map.partial' );
      should have_selector( '.geomap' );
    }

    it ( 'should initialize a map' ) {
      should have_selector( '.geomap.geo-map' );
    }

    # index
    it {
      should have_selector( '.map-index' );
    }
  end
}
