require 'spec_helper'

describe( CountriesHelper ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
  let ( :pct_inet ) { country.indicators.find_by_datum_source_id( DatumSource.find_by_admin_name( 'ds_pct_inet' ).id ) }
  let ( :gdp ) { country.indicators.find_by_datum_source_id( DatumSource.find_by_admin_name( 'ds_gdp' ).id ) }
  let ( :fixed_monthly ) { country.indicators.find_by_datum_source_id( DatumSource.find_by_admin_name( 'ds_fixed_monthly' ).id ) }
  let ( :pop ) { country.indicators.find_by_datum_source_id( DatumSource.find_by_admin_name( 'ds_population' ).id ) }

  subject { helper }

  describe ( 'format_sidebar_value' ) {
    it ( 'should add suffix to pct_inet' ){
      format_sidebar_value( pct_inet ).should eq( '21%' )
    }

    it ( 'should add prefix & ,s to gdp' ){
      format_sidebar_value( gdp ).should eq( '$4,526' )
    }

    it ( 'should use precision with fixed_monthly' ){
      format_sidebar_value( fixed_monthly ).should eq( '$16.57' )
    }

    it ( 'should add ,s to everything else' ) {
      format_sidebar_value( pop ).should eq( '74,798,599' )
    }
  }
}
