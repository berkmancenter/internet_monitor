class CountriesController < ApplicationController
    def index
        @countries = Country.with_enough_data
    end

    def show
        @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}
        @country = Country.find(params[:id])
        respond_to do |format|
            format.html
            format.any(:xml, :json)
        end
    end

    def access
      @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}
      @country = Country.find(params[:id])
      @category = Category.find_by_name( "Access" )
    end

    def control
      @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}
      @country = Country.find(params[:id])
      @category = Category.find_by_name( "Control" )
    end

    def activity
      @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}
      @country = Country.find(params[:id])
      @category = Category.find_by_name( "Activity" )
    end
end
