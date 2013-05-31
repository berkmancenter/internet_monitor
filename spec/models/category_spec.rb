require 'spec_helper'

describe ( 'Category model' ) {
  subject { category }

  describe ( 'with valid data' ) {
    let ( :category ) { FactoryGirl.create( :cat_activity ) }

    it {
      should be_valid
    }
  }
}
