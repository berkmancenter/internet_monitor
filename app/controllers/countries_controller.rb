class CountriesController < ApplicationController
  def index
    last_indicator = Indicator.last
    if stale?( etag: last_indicator, last_modified: last_indicator.updated_at )
      @scored_countries = Country.with_enough_data.desc_score
      @unscored_countries = Country.without_enough_data
      respond_to do |format|
        format.html
        format.any(:xml, :json)
      end
    end
  end

  def cache_thumbs
    render
  end

  def update
    id = params[:id]
    @country = Country.find(id)

    puts '***'
    puts params
    puts params[ :thumb ]
    puts '***'

    render text: 'ok'
  end

  def show
    @country = Country.find(params[:id])

    slug = @country.iso3_code.downcase

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

  def map
    @scored_countries = Country.order( 'score desc' ).with_enough_data
    @unscored_countries = Country.without_enough_data
  end
end
