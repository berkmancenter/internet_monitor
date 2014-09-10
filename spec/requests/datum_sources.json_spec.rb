require 'spec_helper'

describe ( 'datum_sources.json requests' ) {
  describe ( 'get /datum_sources/:id.json' ) {
    context ( 'with xml datum_source' ) {
      let ( :ds ) { DatumSource.find_by_admin_name 'ds_aktv' }

      before {
        visit datum_source_path ds, format: :xml
      }

      it {
        page.status_code.should eq( 200 )
      }

      it {
        Hash.from_xml( source )[ 'locations' ].should_not eq( nil )
      }
    }
  }
}
