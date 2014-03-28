require 'spec_helper'

describe ( 'Indicator model' ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

  context ( 'static methods' ) {
    describe ( 'weighted_score' ) {
      let ( :indicators ) { country.indicators.most_recent.affecting_score }

      it {
        # score for test country > 1.49
        Indicator.weighted_score( indicators ).should > 1.49
      }
    }
  }

  context ( 'class methods' ) {
    describe ( 'calc_percent' ) {
      let ( :ds_consistency ) { DatumSource.find_by_admin_name 'ds_consistency' }
      let ( :d_consistency ) { country.indicators.find_by_datum_source_id ds_consistency.id }
      
      it {
        d_consistency.calc_percent
        d_consistency.percent.nan?.should_not be_true
      }
    }
  }
}
