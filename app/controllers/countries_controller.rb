class CountriesController < ApplicationController
    def index
        @countries = Country.with_enough_data
    end

    def show
        @country = Country.find(params[:id])
    end
end
