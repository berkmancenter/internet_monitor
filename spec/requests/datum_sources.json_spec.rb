require 'spec_helper'

describe ( 'datum_sources.json requests' ) {
  describe ( 'get /datum_sources/:id.json' ) {
    let ( :ds ) { DatumSource.find_by_admin_name 'ds_aktv' }

    before {
      visit datum_source_path ds, format: :json
    }

    it {
      page.status_code.should eq( 200 )
    }

    describe ( 'json' ) {
      let ( :json ) { JSON.parse( page.source ) }

      it {
        json.should_not eq( nil )
      }
    }
  }

}
