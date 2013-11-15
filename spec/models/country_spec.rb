require 'spec_helper'

describe ( 'Country model' ) {
  subject { country }

  context ( 'with valid data' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    it { should be_valid }

    it { should respond_to :indicator_count }

    it { should respond_to :enough_data? }

    it { country.enough_data?.should be_true }
  }

  context ( 'without enough data for a score' ) {
    let ( :country ) { Country.find_by_iso3_code( 'USA' ) }

    it { should be_valid }

    it { country.enough_data?.should be_false }
  }
}

