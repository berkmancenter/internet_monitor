require 'spec_helper'

describe ( 'country_categories/show' ) {
  subject { rendered }

  shared_examples_for ( 'indicators' ) {
    it ( 'should have indicators section in main column' ) {
      should have_css '.main-column div.indicators'

      should have_css '.indicators dl'
    }

    context ( 'with some indicators' ) {
      let ( :data ) {
        category.data.indicators.in_category_page.most_recent.for( country );
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
      should have_css 'h1', text: country.name
    }

    describe ( 'header text' ) {
      it {
        should have_css '.view h1', text: country.name
        should have_css '.view h1', text: category.name
      }

      it {
        should have_css '.view h1.head-banner'
      }
    }

    it ( 'should have category selector' ) {
      # moved from layout
      should have_css '.category-selector'
      should have_css '.category-selector.expanded'
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

  context ( 'full country' ) {
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    before {
      assign( :map_countries, Country.with_enough_data.where( { id: country.id } ).select( 'iso3_code,score' ) )
      assign( :country, country )
    }

    context ( 'access' ) {
      let ( :category ) { Category.find_by_slug( 'access' ) }
      let ( :update ) { strip_tags( Refinery::Page.by_slug( country.iso3_code.downcase ).first.content_for( :access ) ) }
      let ( :ds_fixed_monthly ) { DatumSource.find_by_admin_name( 'ds_fixed_monthly' ) }
      let ( :d_fixed_monthly_country ) { category.data.indicators.most_recent.for( country ).find_by_datum_source_id ds_fixed_monthly.id }
      let ( :ds_fixed_monthly_gdp ) { DatumSource.find_by_admin_name( 'ds_fixed_monthly_gdp' ) }
      let ( :ds_lit_rate ) { DatumSource.find_by_admin_name( 'ds_lit_rate' ) }
      let ( :d_lit_rate_country ) { category.data.indicators.most_recent.for( country ).find_by_datum_source_id ds_lit_rate.id }

      before {
        assign( :category, category )
        assign( :update, update )
        render
      }

      it_should_behave_like 'country_category layout'

      it {
        should have_css '.view h1.access-1-bg'
      }

      it {
        should have_css 'h1 .score-pill'
      }

      it ( 'h1 has country score (inside pill)' ) {
        should have_css 'h1', text: country.score.round(2), exact: true
      }

      it_should_behave_like 'country sidebar'

      it_should_behave_like 'indicators'

      it ( 'should have indicators grouped' ) {
        should have_css '.indicators h2', text: 'Adoption'
        should have_css '.indicators h2', text: 'Speed and Quality'
        should have_css '.indicators h2', text: 'Price'
        should have_css '.indicators h2', text: 'Literacy and Gender Equality'
      }

      it {
        should have_css '.indicators dl', count: 4
      }

      it ( 'should not show bar for indicator not in_category_page' ) {
        should_not have_css 'dt', text: ds_fixed_monthly_gdp.public_name
      }

      it ( 'should show Literacy rate' ) {
        should have_css 'dt', text: ds_lit_rate.public_name
      }

      it ( 'should no longer have original value in title' ) {
        should_not have_css "dd[title]"
      }
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

      it {
        should_not have_css 'h1 .score-pill'
      }

      it_should_behave_like 'country sidebar'

      it_should_behave_like 'indicators'

      it ( 'should have indicators grouped' ) {
        should have_css '.indicators h2', text: 'Internet Control'
        should have_css '.indicators h2', text: 'Internet Filtering'
        should have_css '.indicators h2', text: 'Internet Filtering MO'
      }

      it ( 'should have filtering specific indicators view' ) {
        should have_css '.indicators-label span', text: 'No evidence of filtering'
      }

      it ( 'should have filtering specific indicators view' ) {
        should have_css '.indicators-label span', text: 'Low'
      }

      it {
        should have_css '.indicators dl', count: 3
      }

      it ( 'should have a herdict quickstats report' ) {
        # control sample has one
        should have_css 'section.herdict-quickstats-fetcher.html-block'
        should have_css '.herdict-quickstats-fetcher .quickstats'
      }

      it ( 'should have a herdict topitems report' ) {
        # control sample has one
        should have_css 'section.herdict-fetcher.html-block'
        should have_css '.herdict-fetcher .topitems'
      }

      it ( 'should not allow script tags in the herdict topitems report' ) {
        should_not have_css '.herdict-fetcher script', visible: false
        should_not have_css '.herdict-fetcher div', text: 'topsitescategory'
      }
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

      it {
        should_not have_css 'h1 .score-pill'
      }

      it_should_behave_like 'country sidebar'

      it {
        should_not have_css 'section.indicators'
      }

      it ( 'should have a morningside widget' ) {
        # activity sample has one
        should have_css 'section.morningside-fetcher.json-object'
        should have_css '.morningside-fetcher .render'
      }

      it ( 'should only have *one* morningside widget' ) {
        # because the second one does not have a page in refinery & is ignored
        should have_css 'section.morningside-fetcher.json-object', count: 2
      }

      it ( 'should have morningside header' ) {
        # headers come from cms page title
        should have_css 'section.morningside-fetcher h1', text: 'ds_morningside_1'
      }

      it ( 'should have morningside description' ) {
        # description comes from cms page body
        should have_css 'section.morningside-fetcher .body', text: 'Researchers at Berkman are currently working to analyze this data.'
      }

      it ( 'should have a note under the blogosphere' ) {
        # description comes from cms page side_body
        should have_css 'section.morningside-fetcher .side_body', text: 'For an earlier report on the Arabic blogosphere using similar research methods, see "Mapping the Arabic Blogosphere: Politics, Culture and Dissent" (2009).'
      }

      it {
        should_not have_css '.block.no-data'
      }
    }
  }

  context ( 'country without activity' ) {
    let ( :country ) { Country.find_by_iso3_code( 'CHN' ) }

    before {
      assign( :map_countries, Country.with_enough_data.where( { id: country.id } ).select( 'iso3_code,score' ) )
      assign( :country, country )
    }

    context ( 'activity' ) {
      let ( :category ) { Category.find_by_slug( 'activity' ) }

      before {
        assign( :category, category )
        render
      }

      it {
        should have_css '.block.no-data', text: 'We do not currently have activity data to display for China.'
      }
    }
  }
}
