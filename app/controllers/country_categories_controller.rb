class CountryCategoriesController < ApplicationController
  def show
    country_category = CountryCategory.find(params[:id]);

    @country = country_category.country
    @category = country_category.category
  end
end
