class CountriesController < ApplicationController
  def index
    last_indicator = Indicator.last
    if stale?( etag: last_indicator, last_modified: last_indicator.updated_at )
      # Removed with_enough_data scope call
      @scored_countries = Country.desc_score.all
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
    if params[ :country ][ :thumb ].present?
      id = params[:id]
      @country = Country.find(id)

      File.open( Rails.root.join( 'app', 'assets', 'images', 'countries', "#{@country.iso3_code}.png" ), 'wb') do |f|
        f.write(params[:country][:thumb].read)
      end

      render text: 'ok'
    else
      render text: 'error'
    end
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

  def thumb
    @country = Country.find(params[:id])
    send_data File.open( Rails.root.join( 'app', 'assets', 'images', 'countries', "#{@country.iso3_code}.png" ), 'rb' ).read, type: 'image/png', disposition: 'inline'
  end
  
end
