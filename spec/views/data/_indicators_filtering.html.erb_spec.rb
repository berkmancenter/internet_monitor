require 'spec_helper'

describe ( 'data/_indicators_filtering' ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

  let ( :category ) { Category.find_by_slug( 'control' ) }
  let ( :group ) { Group.find_by_admin_name 'filtering' }

  let ( :grouped ) {
    category.data.indicators.in_category_page.most_recent.for( country ).group_by { |i|
      i.source.group
    }
  }

  subject { rendered }

  before {
    assign( :category, category )
    render 'data/indicators_filtering', indicators_filtering: grouped[ group ], group: group 
  }

  it {
    should have_css 'h2', text: group.public_name
  }

  it {
    should have_css '.indicators-label span', text: 'no evidence'
  }
}

