require 'spec_helper'

describe ( 'shared/widgets/_weight_sliders' ) {
  subject { rendered }

  context ( 'normal indicator' ) {
    let ( :access ) { Category.find_by_slug 'access' }
    let ( :groups ) {  DatumSource.where( { category_id: access.id } ).map { |ds| ds.group }.uniq }
    let ( :adoption ) { groups.first }

    before {
      render 'shared/widgets/weight_sliders', groups: groups, background_color: '#ff0000'
    }

    it {
      should have_css 'form#weight-sliders'
    }

    it {
      should have_css 'ul.weight-sliders-list'
    }

    it {
      should have_css 'label', text: adoption.public_name
      should have_css "label[for='range-#{adoption.admin_name}']"
    }

    it {
      should have_css "input[id='range-#{adoption.admin_name}']"
    }

    it {
      should have_css "input[name='#{adoption.admin_name}']"
    }

    it {
      should_not have_css 'input[data-source-id]'
    }

    it {
      should have_css 'input[data-source-ids]'
    }

    it {
      should have_css 'input[data-default-weight]'
    }

    it {
      # sliders for only the four access groups
      should have_css "input[type='range']", count: 4
    }

    it {
      should have_css "input[type='range'][min='0'][max='2'][step='0.1']"
    }

    it {
      should have_css "input[data-background-min][data-background-max]"
    }

    it { 
      should have_css 'button[type="reset"]'
    }
  }
}
