require 'spec_helper'

describe ( 'countries.json requests' ) {
  describe ( 'get /countries.json' ) {
    before {
      visit countries_path( :format => :json )
      
    }

    it {
      page.status_code.should eq( 200 )
    }

    describe ( 'json' ) {
      let ( :countries ) { JSON.parse( page.source ) }

      it {
        countries.class.should eq( Array )
        countries.count.should > 0
      }

      describe ( 'country hash' ) {
        let ( :country ) { countries[ 0 ][ 'country' ] }

        it {
          country[ 'id' ].should_not eq( nil )
          country[ 'name' ].should_not eq( nil )
          country[ 'score' ].should_not eq( nil )
        }

        it {
          country[ 'indicators' ].should_not eq( nil )
          country[ 'indicators' ].class.should eq( Array )
        }

        describe ( 'indicator hash' ) {
          let ( :indicator ) { country[ 'indicators' ][ 0 ] }

          it {
            indicator[ 'value' ].should_not eq( nil )
            indicator[ 'normalized_value' ].should_not eq( nil )
            indicator[ 'source_id' ].should_not eq( nil )
            indicator[ 'default_weight' ].should_not eq( nil )
            indicator[ 'category' ].should eq( 'Access' )
            indicator[ 'group' ].should_not eq( nil )
          }
        }
      }
    }
  }

}
