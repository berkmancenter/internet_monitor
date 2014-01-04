require 'spec_helper'

describe ( 'country_categories/show' ) {
  subject { rendered }

  shared_examples_for ( 'indicators' ) {
    it ( 'should have indicators section in main column' ) {
      should have_css '.main-column section.indicators'

      should have_css '.indicators dl'
    }

    context ( 'with some indicators' ) {
      let ( :data ) {
        category.data.most_recent.for( country );
      }

      it {
        should have_css 'dt', text: data.first.source.public_name
      }
    }
  }

  shared_examples_for ( 'country_category layout' ) {
    it {
      should have_css '.view.country-data-view'
    }

    it {
      should have_css '.view h1', text: country.name
      should have_css '.view h1', text: category.name
    }

    it {
      should have_css 'h1 .score-pill'
    }

    it ( 'h1 has country name score (inside pill)' ) {
      should have_css 'h1', text: country.name
      should have_css 'h1', text: country.score.round(2), exact: true
    }

    it ( 'h1 & .sub-content are siblings' ) {
      should have_css 'h1~.sub-content'
    }

    it ( 'should have main & sidebar columns' ) {
      should have_css '.sub-content .main-column'
      should have_css '.sub-content .sidebar-column'
    }

    it ( 'should have a country category update block' ) {
      should have_css ".main-column .update.#{category.slug}.block"
    }

    it ( 'should pull the category update text from a refinery page' ) {
      should have_css '.update', text: update
    }
  }

  shared_examples_for ( 'country sidebar' ) {
    it ( 'should have a country sidebar' ) {
      should have_css '.sidebar-column .sidebar.block'
    }

    it ( 'no more country dropdown in sidebar' ) {
      should_not have_css '.sub-content .country-data'
    }

    it ( 'should not have generic indicators in sidebar' ) {
      should_not have_css '.sidebar .indicators'
    }

    it ( 'should have sidebar data' ) {
      should have_css '.sidebar dt', text: 'Population'
    }
  }

  context ( 'normal country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before {
      assign( :map_countries, Country.with_enough_data.where( { id: country.id } ).select( 'iso3_code,score' ) )
      assign( :country, country )
    }

    context ( 'access' ) {
      let ( :category ) { Category.find_by_slug( 'access' ) }
      let ( :update ) { strip_tags( Refinery::Page.by_slug( country.iso3_code.downcase ).first.content_for( :access ) ) }

      before {
        assign( :category, category )
        assign( :update, update )
        render
      }

      it_should_behave_like 'country_category layout'

      it_should_behave_like 'country sidebar'

      it_should_behave_like 'indicators'
    }

    context ( 'control' ) {
      let ( :category ) { Category.find_by_slug( 'control' ) }
      let ( :update ) { strip_tags( Refinery::Page.by_slug( country.iso3_code.downcase ).first.content_for( :control ) ) }

      before {
        assign( :category, category )
        assign( :update, update )
        render
      }

      it_should_behave_like 'country_category layout'

      it_should_behave_like 'country sidebar'

      it_should_behave_like 'indicators'
    }

    context ( 'activity' ) {
      let ( :category ) { Category.find_by_slug( 'activity' ) }
      let ( :update ) { strip_tags( Refinery::Page.by_slug( country.iso3_code.downcase ).first.content_for( :activity ) ) }

      before {
        assign( :category, category )
        assign( :update, update )
        render
      }

      it_should_behave_like 'country_category layout'

      it_should_behave_like 'country sidebar'

      it {
        should_not have_css 'section.indicators'
      }

      it {
        # activity sample has a morningside widget
        should have_css 'div.json-objects'
        should have_css '.json-objects .morningside-fetcher'
      }
    }
  }
}
