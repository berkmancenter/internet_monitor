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
    @map_countries = Country.with_enough_data.select( 'id,iso3_code,score' )
    @country = Country.find(params[:id])

    @update = nil
    page = Refinery::Page.by_slug @country.iso3_code.downcase

    if params[:category_slug]
      @category = Category.find(params[:category_slug])
      render "country_categories/show"
    else
      @update = page.first.content_for( :body ) unless page.empty?
      respond_to do |format|
        format.html
        format.any(:xml, :json)
      end
    end
  end

  def map
    @map_countries = Country.with_enough_data.select( 'id,iso3_code,score' )
    @scored_countries = Country.order( 'score desc' ).with_enough_data
    @unscored_countries = Country.without_enough_data
  end
end
