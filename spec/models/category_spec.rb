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
        category.slug.should eq( 'access' )
      }

      it {
        category.name.should eq( 'Access' )
      }

      it {
        should respond_to :data
      }
    }
  }
}
