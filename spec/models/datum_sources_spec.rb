require 'spec_helper'

describe ( 'DatumSource model' ) {
  describe ( 'with valid data' ) {
    let ( :ds_access ) { FactoryGirl.create( :ds_access ) }

    subject { ds_access }

    it {
      should be_valid
    }

    describe ( 'with category' ) {
      let ( :cat_access ) { FactoryGirl.create( :cat_access ) }

      subject { ds_access.category }

      it {
        should = cat_access
      }
    }
  }
}


