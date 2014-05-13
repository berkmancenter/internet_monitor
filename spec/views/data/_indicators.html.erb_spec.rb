require 'spec_helper'

describe ( 'data/_indicators' ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

  subject { rendered }

  context ( 'control indicators' ) {
    let ( :category ) { Category.find_by_slug( 'control' ) }
    let ( :grouped ) {
      category.data.indicators.in_category_page.most_recent.for( country ).group_by { |i|
        i.source.group
      }
    }
    let ( :group ) { grouped.first }

    before {
      assign( :category, category )
      render 'data/indicators', indicators: group[ 1 ], group: group[ 0 ]
    }

    it {
      should have_css 'h2', text: group[0].public_name
    }

    it {
      should have_css '.indicators-label span', text: 'worst'
    }
  }
}

