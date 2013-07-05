require 'spec_helper'

describe ( 'DatumSource model' ) {
  describe ( 'with valid data' ) {
    let ( :ds_pct_inet ) { DatumSource.find_by_admin_name( 'ds_pct_inet' ) }

    subject { ds_pct_inet }

    it {
      should be_valid
    }

    describe ( 'with category' ) {
      let ( :cat_access ) { Category.find_by_name( 'Access' ) }

      subject { ds_pct_inet.category }

      it {
        should = cat_access
      }
    }
  }
}


