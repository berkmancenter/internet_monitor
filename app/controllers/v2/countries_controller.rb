class V2::CountriesController < ApplicationController
  def index
    @countries = Country.all
    render json: {
      data: @countries.map { |c|
        json = c.as_jsonapi_v2
        json[ :links ][ :self ] = v2_country_url( c )

        json
      }
    }
  end

  def show
    @country = Country.find(params[:id])
    json = @country.as_jsonapi_v2
    json[ :links ][ :self ] = v2_country_url( @country )
    render json: {
      data: json
    }
  end

end
