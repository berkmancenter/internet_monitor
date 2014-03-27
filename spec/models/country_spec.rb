require 'spec_helper'

describe ( 'Country model' ) {
  subject { country }

  context ( 'with valid data' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    it { should be_valid }

    it { should respond_to :indicator_count }

    it { should respond_to :access_group_count }

    it { should respond_to :enough_data? }

    it { country.enough_data?.should be_true }

    it { country.access_group_count.should eq( 4 ) }

    describe ( 'calculate_score!' ) {
      before {
        country.calculate_score!
      }

      it ( 'should have recalculated score & still be valid' ) {
        should be_valid
        country.score.should > 1.49 
      }
    }
  }

  context ( 'without enough data for a score' ) {
    let ( :country ) { Country.find_by_iso3_code( 'USA' ) }

    it { should be_valid }

    it { country.enough_data?.should be_false }
  }

  describe ( 'Country.calculate_scores_and_rank!' ) {
    let ( :enough_data ) { Country.find_by_iso3_code( 'IRN' ) }
    let ( :not_enough ) { Country.find_by_iso3_code( 'USA' ) }

    before {
      Country.calculate_scores_and_rank!
    }

    it ( 'should rank countries with enough data' ) {
      enough_data.rank.should eq( 2 )
    }

    it ( 'should not rank countries without enough data' ) {
      not_enough.rank.should eq( nil )
    }
  }
}

