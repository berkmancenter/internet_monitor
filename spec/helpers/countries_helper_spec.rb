require 'spec_helper'

describe( CountriesHelper ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
  let ( :gdp ) { country.indicators.find_by_datum_source_id( DatumSource.find_by_admin_name( 'ds_gdp' ).id ) }
  let ( :pop ) { country.indicators.find_by_datum_source_id( DatumSource.find_by_admin_name( 'ds_population' ).id ) }

  subject { helper }

  it ( 'should add $ & ,s to gdp' ){
    format_sidebar_value( gdp ).should eq( '$4,526' )
  }

  it ( 'should add ,s to everything else' ) {
    format_sidebar_value( pop ).should eq( '74,798,599' )
  }
}