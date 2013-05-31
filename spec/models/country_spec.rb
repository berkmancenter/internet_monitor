require 'spec_helper'

describe ( 'Country model' ) {
  subject { country }

  describe ( 'with valid data' ) {
    let ( :country ) { FactoryGirl.create( :country ) }

    it {
      should be_valid
    }
  }
}

