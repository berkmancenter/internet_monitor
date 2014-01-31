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

      it {
        should respond_to :indicators
      }

      it ( 'should have indicators' ) {
        # currently causes database exception
        # should be shortcut for 
        # category.data.where { type: Indicator }
        pending 'category.indicators.count.should > 0'
        category.indicators.count.should > 0
      }
    }
  }
}
