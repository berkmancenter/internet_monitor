class CountriesController < ApplicationController
    def index
        @countries = Country.with_enough_data
    end

    def show
        @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}
        @country = Country.find(params[:id])
    end

    def activity
      @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}
      @country = Country.find(params[:id])
      @category = Category.find_by_name( "Activity" )
    end
end
