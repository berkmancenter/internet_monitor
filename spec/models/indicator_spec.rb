require 'spec_helper'

describe ( 'Indicator model' ) {
  context ( 'static methods' ) {
    describe ( 'weighted_score' ) {
      let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
      let ( :indicators ) { country.indicators.most_recent.affecting_score }

      it {
        # score for test country > 1.49
        Indicator.weighted_score( indicators ).should > 1.49
      }
    }
  }
}
