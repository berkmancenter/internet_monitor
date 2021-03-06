require 'spec_helper'

describe ( 'CountryCategory model' ) {
  let ( :country ) { Country.find_by_iso3_code( 'IRN' ) }
  let ( :country_category ) { CountryCategory.where( { country_id: country.id, category_id: Category.find_by_slug( 'access' ) } ).first }

  subject { country_category }

  context ( 'with valid data' ) {
    it { should be_valid }

    it { should respond_to :indicators }

    it { should_not respond_to :score }
  }
}

