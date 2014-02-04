require 'spec_helper'

describe ( 'Category model' ) {
  subject { category }

  context ( 'access' ) {
    let ( :category ) { Category.find_by_slug 'access' }

    describe ( 'with valid data' ) {

      it {
        should be_valid
      }

      it {
        should respond_to :data
      }
    }
  }
}
