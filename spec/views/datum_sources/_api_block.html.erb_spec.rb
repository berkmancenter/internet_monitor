require 'spec_helper'

describe ( 'datum_sources/_api_block' ) {
  let ( :ds_aktv ) { DatumSource.find_by_admin_name 'ds_aktv' }
  let ( :country ) { Country.find_by_name 'Iran' }

  subject { rendered }

  before {
    assign( :country, country )
    render partial: 'datum_sources/api_block', object: ds_aktv
  }

  it {
    should have_css '.block'
  }

  it {
    should have_css %*.block[data-datum-source-id="#{ds_aktv.id}"]*
  }

  it {
    should have_css %*.block[data-country-iso3="#{country.iso3_code}"]*
    should have_css %*.block[data-country-iso2="#{country.iso_code}"]*
  }
}

