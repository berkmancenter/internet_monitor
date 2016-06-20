class V2::CountriesController < ApplicationController
  def index
    @countries = Country.with_enough_data.desc_score

    indicators = []
    @countries.each { |c|
      indicators |= c.indicators.in_current_index
    }
    render json: {
      data: @countries.map { |c|
        json = c.as_jsonapi
        json[ :links ][ :self ] = v2_country_url( c )

        json
      },
      included: indicators.map( &:as_jsonapi )
    }
  end

  def show
    @country = Country.with_enough_data.find(params[:id])
    json = @country.as_jsonapi_v2
    json[ :links ][ :self ] = v2_country_url( @country )
    render json: {
      data: json
    }
  end

end
