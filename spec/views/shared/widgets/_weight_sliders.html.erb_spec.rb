require 'spec_helper'

describe ( 'shared/widgets/_weight_sliders' ) {
  subject { rendered }

  context ( 'normal indicator' ) {
    let ( :groups ) { Group.all }
    let ( :adoption ) { groups.first }

    before {
      render 'shared/widgets/weight_sliders', groups: groups, background_color: '#ff0000'
    }

    it {
      should have_css 'ul.weight-sliders-list'
    }

    it {
      should have_css 'label', text: adoption.public_name
      should have_css "label[for='range-#{adoption.admin_name}']"
    }

    it {
      should have_css "input[id='range-#{adoption.admin_name}'][name='#{adoption.admin_name}']"
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
      should have_css "input[type='range'][min='0'][max='2'][step='0.1']"
    }

    it {
      should have_css "input[data-background-min][data-background-max]"
    }
  }
}
