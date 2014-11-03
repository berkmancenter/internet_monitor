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
      let ( :parsed ) { JSON.parse( page.source ) }

      it {
        parsed.class.should eq( Hash )
        parsed[ 'cs' ].should_not eq( nil ) # countries
      }

      describe ( 'countries hash' ) {
        let ( :countries ) { parsed[ 'cs' ] }

        describe ( 'country hash' ) {
          let ( :country ) { countries[ 0 ][ 'c' ] }

          it {
            country[ 'id' ].should_not eq( nil )
            country[ 'n' ].should_not eq( nil ) # name
            country[ 's' ].should_not eq( nil ) # score
          }

          it {
            country[ 'data' ].should_not eq( nil ) # indicators
            country[ 'data' ].class.should eq( Array )
          }

          describe ( 'indicator hash' ) {
            let ( :indicator ) { country[ 'data' ][ 0 ] }

            it {
              indicator[ 'v' ].should_not eq( nil ) # value
              indicator[ 'nv' ].should_not eq( nil ) # normalized_value
              indicator[ 'sid' ].should_not eq( nil ) # source_id
              indicator[ 'dw' ].should_not eq( nil ) # default_weight
              indicator[ 'c' ].should eq( 'Access' ) # category
              indicator[ 'g' ].should_not eq( nil ) # group
            }
          }
        }
      }
    }
  }

}
