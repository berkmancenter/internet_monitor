require 'spec_helper'

describe ( 'map requests' ) {
  subject { page }

  describe 'get /map', :js => true do
    before { visit map_path }
    it {
      should have_title 'Map | Internet Monitor'
    }

    # map
    it {
      should have_css 'section.map.partial'
      should have_css '.geomap'
    }

    it ( 'should initialize a map' ) {
      should have_css '.geomap.geo-map'
    }

    it ( 'should not have a default basemap' ) {
      should have_css '#map-countries-service.geo-service'
      should have_css '#map-highlight-service.geo-service'
    }
  end
}
