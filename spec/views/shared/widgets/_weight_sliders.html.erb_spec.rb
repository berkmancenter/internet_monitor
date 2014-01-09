require 'spec_helper'

describe ( 'shared/widgets/_weight_sliders' ) {
  subject { rendered }

  context ( 'normal indicator' ) {
    let ( :indicator_sources  ) { DatumSource.where( { admin_name: 'ds_pct_inet' } ) }
    let ( :ds_pct_inet ) { indicator_sources.first }

    before {
      assign( :indicator_sources, indicator_sources )
      render 'shared/widgets/weight_sliders', indicator_sources: indicator_sources
    }

    it {
      should have_css 'h4', text: 'ACCESS'
    }

    it {
      should have_css 'h4', text: 'CONTROL'
    }

    it {
      should have_css 'ul.weight-sliders-list', count: 2
    }

    it {
      should have_css 'label', text: ds_pct_inet.public_name
      should have_css "label[for='range-#{ds_pct_inet.admin_name}']"
    }

    it {
      should have_css "input[id='range-#{ds_pct_inet.admin_name}'][name='#{ds_pct_inet.admin_name}']"
    }

    it {
      should have_css "input[type='range'][min='0'][max='2'][step='0.1']"
    }

    it {
      should have_css "input[data-background-min][data-background-max]"
    }
  }
}
