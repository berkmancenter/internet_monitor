require 'spec_helper'

describe ( DatumSourcesController ) {
  context ( 'with json api' ) {
    describe ( 'GET show.json' ) {
      let ( :ds ) { DatumSource.find_by_admin_name 'ds_aktv' }

      before {
        get :show, id: ds.id, format: :json
      }

      it {
        puts response.inspect
        response.code.should eq( '200' )
      }
    }
  }
}



