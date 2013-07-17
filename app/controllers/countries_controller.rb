class CountriesController < ApplicationController
    def index
        @scored_countries = Country.with_enough_data.desc_score
        @unscored_countries = Country.without_enough_data
        respond_to do |format|
            format.html
            format.any(:xml, :json)
        end
    end

    def show
        @country = Country.find(params[:id])
        if params[:category_slug]
            @category = Category.find(params[:category_slug])
            render "country_categories/show"
        else
            respond_to do |format|
                format.html
                format.any(:xml, :json)
            end
        end
    end
end
