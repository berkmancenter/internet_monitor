require 'spec_helper'

describe 'country_categories requests', :js => true do
  describe ( 'get /country_categories show' ) {
    let ( :category ) { Category.find_by_slug( 'activity' ) }
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    subject { page }

    context ( 'control' ) {
      before {
        visit category_country_path( country, :category_slug => 'access' )
      }

      it {
        should have_title "#{country.name} Access | Internet Monitor"
      }
    }

    context ( 'control' ) {
      before {
        visit category_country_path( country, :category_slug => 'control' )
      }

      it {
        should have_title "#{country.name} Control | Internet Monitor"
      }

      it ( 'should have herdict content' ) {
        should have_css 'section.herdict-fetcher.html-block h2', text: 'TOP REPORTED SITES'
      }

      it ( 'should have herdict widget' ) {
        should have_css '.sidebar-column section.block .herdict-widget'
      }
    }

    context ( 'activity' ) {
      before {
        visit category_country_path( country, :category_slug => 'activity' )
      }

      it {
        should have_title "#{country.name} Activity | Internet Monitor"
      }

      it ( 'should have a morningside blogosphere with content' ) {
        should have_css 'section.morningside-fetcher.json-object .render svg'
      }
    }
  }
end
