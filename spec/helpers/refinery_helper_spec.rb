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
}
