require 'spec_helper'

describe ( 'data/_indicator_filtering' ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

  subject { rendered }

  shared_examples_for ( 'indicator_filtering' ) {
    it {
      should have_css 'dt', text: indicator.name
    }

    it {
      should have_css "dt a[title='Source: #{ ds.source_name }']"
    }

    it ( 'should link to the sources cms page' ) {
      should have_css 'dt a[href*="/sources"]'
    }

    it {
      # moved to span next to inner bar
      should_not have_css 'dd[title]'
    }

    it {
      should have_css 'dd span.indicator-bar-outer'
    }

    it {
      should have_css 'dd span.indicator-bar-outer span.indicator-bar-inner'
    }

    it {
      should have_css 'span.indicator-bar-inner'
    }

    it ( 'inner width' ) {
      should have_css 'span.indicator-bar-inner[style*="100"]'
    }

    it {
      # filtering indicators don't show value
      should_not have_css 'span.original-value'
    }
  }

  context ( 'filtering group indicators' ) {
    let ( :category ) { Category.find_by_slug( 'control' ) }

    context ( 'social' ) {
      # social is of group filtering
      let ( :ds ) { DatumSource.find_by_admin_name( 'ds_social' ) }
      let ( :indicator ) { country.indicators.where( { datum_source_id: ds.id } ).first }

      before {
        assign( :category, category )
        render 'data/indicator_filtering', indicator_filtering: indicator
      }
      
      it_should_behave_like 'indicator_filtering'
    }
  }
}

