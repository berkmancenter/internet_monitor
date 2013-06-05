require 'spec_helper'

describe ( 'Category model' ) {
  subject { access }

  describe ( 'with valid data' ) {
    let ( :access ) { Category.find_by_name( 'Access' ) }

    it {
      should be_valid
    }
  }
}
