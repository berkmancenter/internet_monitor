require 'spec_helper'

describe ( DatumSourcesController ) {
  context ( 'with json api datum_source' ) {
    describe ( 'GET show.json' ) {
      let ( :ds ) { DatumSource.find_by_admin_name 'ds_aktv' }

      before {
        get :show, id: ds.id, format: :json
      }

      it {
        response.code.should eq( '200' )
      }
    }
  }

  context ( 'with non-api datum_source' ) {
    describe ( 'GET show.json' ) {
      let ( :ds ) { DatumSource.find_by_admin_name 'ds_fixed_monthly_gdp' }

      before {
        get :show, id: ds.id, format: :json
      }

      it {
        response.code.should eq( '404' )
      }
    }
  }


}



