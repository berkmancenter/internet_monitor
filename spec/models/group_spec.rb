require 'spec_helper'

describe ( 'Group model' ) {
  subject { group }

  describe ( 'with valid data' ) {
    let ( :group ) { Group.find_by_admin_name 'adoption' }

    it {
      should be_valid
    }

    it {
      should respond_to :admin_name
      should respond_to :public_name
    }

    it {
      group.public_name.should eq( 'Adoption' )
    }
  }
}
