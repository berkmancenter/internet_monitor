require 'spec_helper'

describe ( 'Datum model' ) {
  let ( :ds_pct_inet ) { DatumSource.find_by_admin_name( 'ds_pct_inet' ) }
  let ( :ds_social ) { DatumSource.find_by_admin_name( 'ds_social' ) }
  let ( :iran ) { Country.find_by_iso3_code( 'IRN' ) }
  let ( :china ) { Country.find_by_iso3_code( 'CHN' ) }
  let ( :usa ) { Country.find_by_iso3_code( 'USA' ) }

  let ( :d_pct_inet_iran ) {
    Datum.where( {
      datum_source_id: ds_pct_inet.id,
      country_id: iran.id
    } ).first
  }

  let ( :d_pct_inet_china ) {
    Datum.where( {
      datum_source_id: ds_pct_inet.id,
      country_id: china.id
    } ).first
  }

  let ( :d_social_china ) {
    Datum.where( {
      datum_source_id: ds_social.id,
      country_id: china.id
    } ).first
  }

  context ( 'with valid data' ) {
    it {
      d_pct_inet_iran.should be_valid
    }

    describe ( 'value' ) {
      it {
        d_pct_inet_iran.value.should eq( 0.0 )
      }

      it {
        d_pct_inet_china.value.should eq( 1.0 )
      }
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

  context ( 'with non-normalized DatumSource' ) {
    it {
      # non-normalized datum values equal their original_value
      # unrelated to other countries
      d_social_china.value.should eq( 3.0 )
    }
  }
}
