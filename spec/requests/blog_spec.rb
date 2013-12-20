require 'spec_helper'

describe ( 'blog requests' ) {
  subject { page }

  describe ( 'get /blog' ) {
    before { visit refinery::blog_root_path }

    it {
      should have_css 'body.refinery-blog-posts'
    }

    it {
      should have_css 'body.refinery-blog-posts.index'
    }
  }
}
