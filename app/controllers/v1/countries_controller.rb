class V1::CountriesController < ApplicationController
  def index
    @countries = Country.with_enough_data.desc_score

    indicators = []
    @countries.each { |c|
      indicators |= c.indicators.most_recent
    }
    render json: {
      data: @countries.map { |c|
        json = c.as_jsonapi
        json[ :links ][ :self ] = v1_url( c )

        json
      },
      included: indicators.map( &:as_jsonapi )
    }
  end

  def show
    @country = Country.with_enough_data.find(params[:id])
    json = @country.as_jsonapi
    json[ :links ][ :self ] = v1_url( @country )
    render json: {
      data: json,
      included: @country.indicators.map( &:as_jsonapi )
    }
  end

end
