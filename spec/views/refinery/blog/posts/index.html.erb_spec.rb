require 'spec_helper'
require 'will_paginate/array'

def page_title
  'Blog'
end

include Refinery::Pages::ContentPagesHelper

describe ( 'refinery/blog/posts/index' ) {

  subject { rendered }

  context ( 'default view' ) {
    let ( :page ) { Refinery::Page.find_by_slug( 'blog' ) }
    let ( :posts ) { Refinery::Blog::Post.all.paginate( :page => 1, :per_page => 2 ) }

    before {
      assign :page, page
      assign :posts, posts
      render
    }

    it {
      should have_css 'h1', text: 'Blog'
    }
  }
}
