require 'spec_helper'

describe 'country_categories requests', :js => true do
  describe ( 'get /country_categories show' ) {
    let ( :category ) { Category.find_by_slug( 'activity' ) }
    let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }

    subject { page }

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
