require 'spec_helper'

describe ( 'DatumSource model' ) {
  describe ( 'with valid data' ) {
    let ( :ds_access ) { DatumSource.find_by_admin_name( 'ds_access' ) }

    subject { ds_access }

    it {
      should be_valid
    }

    describe ( 'with category' ) {
      let ( :cat_access ) { Category.find_by_name( 'Access' ) }

      subject { ds_access.category }

      it {
        should = cat_access
      }
    }
  }
}


