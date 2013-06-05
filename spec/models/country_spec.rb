require 'spec_helper'

describe ( 'Country model' ) {
  subject { iran }

  describe ( 'with valid data' ) {
    let ( :iran ) { Country.find_by_iso3_code( 'IRN' ) }

    it {
      should be_valid
    }
  }
}

