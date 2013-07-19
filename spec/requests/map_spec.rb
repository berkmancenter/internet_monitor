require 'spec_helper'

describe ( 'map requests' ) {
  subject { page }

  describe ( 'get /map' ) {
    before { visit map_path }

    it {
      should have_selector( '.geomap' );
    }
  }
}
