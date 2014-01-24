require 'spec_helper'

describe( RefineryHelper ) {
  let ( :iran_page_access ) { FactoryGirl.attributes_for :iran_page_access }
  let ( :iran_page_control ) { FactoryGirl.attributes_for :iran_page_control }

  subject { helper }

  describe ( 'part_content' ) {
    context ( 'valid slug and part' ) {
      it ( 'should return content for page part by name' ) {
        part_content( 'irn', 'Access' ).should eq( "<p>#{iran_page_access[ :body ]}</p>" )
      }

      it ( 'should return content for page part by label' ) {
        part_content( 'irn', :control ).should eq( "<p>#{iran_page_control[ :body ]}</p>" )
      }
    }
    context ( 'missing part' ) {
      it ( 'should return nil' ) {
        part_content( 'irn', 'Foo' ).should eq( nil )
      }
    }
  }

  describe ( 'imon_tweets' ) {
    it ( 'should return last five thenetmonitor tweets' ) {
      imon_tweets.count.should eq( 7 )
    }
  }

  describe ( 'home_carousel' ) {
    let ( :carousel_data ) { home_carousel }

    it ( 'should have carousel content' ) {
      carousel_data.count.should eq( 2 )
    }

    it ( 'should link to about first' ) {
      carousel_data.first[ :link_url ].should eq( '/about' )
      carousel_data.first[ :body ].match( /Lorem ipsum/ ).should_not eq( nil )
    }

    it ( 'should link to map last' ) {
      carousel_data.last[ :link_url ].should eq( '/map' )
      carousel_data.last[ :body ].match( /Explore map/ ).should_not eq( nil )
    }
  }
}
