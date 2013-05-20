class CountriesController < ApplicationController
    def index
        @countries = Country.with_enough_data
    end

    def show
        @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}
        @country = Country.find(params[:id])
    end

    def activity
      countryCategory = CountryCategory.find_by_country_id_and_category_id( params[:id], 2 )

      @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}

      @country = countryCategory.country
      @category = countryCategory.category
    end
end
