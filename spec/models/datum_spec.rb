require 'spec_helper'

describe ( 'Datum model' ) {
  subject { datum }

  context ( 'with valid data' ) {
    let ( :ds_pct_inet ) { DatumSource.find_by_admin_name( 'ds_pct_inet' ) }
    let ( :datum ) { Datum.where( { datum_source_id: ds_pct_inet.id } ).first }

    it {
      should be_valid
    }
  }

  context ( 'only indicators' ) {
    it {
      Datum.indicators.count.should_not eq( 0 )
    }
  }

  context ( 'only non-indicators' ) {
    it {
      # there are some like herdict & morningide
      Datum.non_indicators.count.should eq( 3 )
    }
  }
}
