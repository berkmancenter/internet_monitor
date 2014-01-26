require 'spec_helper'

describe ( 'data/_indicator' ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

  subject { rendered }

  context ( 'access indicator' ) {
    let ( :category ) { Category.find_by_slug( 'access' ) }
    let ( :ds ) { DatumSource.where( { category_id: category.id } ).first }
    let ( :indicator ) { country.indicators.where( { datum_source_id: ds.id } ).first }

    before {
      assign( :category, category )
      render 'data/indicator', indicator: indicator
    }

    it {
      should have_css 'dt', text: indicator.name
    }

    it {
      should have_css "dt[title='#{ ds.source_name }']"
    }

    it {
      should have_css "dd[title='#{ number_with_precision( indicator.original_value, { precision: 0, delimiter: ',' } ) }']"
    }
  }
}
