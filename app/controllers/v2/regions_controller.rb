class V2::RegionsController < ApplicationController
  def index
    @regions = Region.order( 'iso3_code asc' )

    indicators = []
    @regions.each { |c|
      indicators |= c.indicators.in_current_index
    }
    render json: {
      data: @regions.map { |c|
        json = c.as_jsonapi
        json[ :links ][ :self ] = v2_region_url( c )

        json
      },
      included: indicators.map( &:as_jsonapi )
    }
  end

  def show
    @region = Region.find(params[:id])
    json = @region.as_jsonapi
    json[ :links ][ :self ] = v2_region_url( @region )
    render json: {
      data: json,
      included: @region.indicators.in_current_index.map( &:as_jsonapi )
    }
  end

end
