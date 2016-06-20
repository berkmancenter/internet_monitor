class V2::DatumSourcesController < ApplicationController
  def index
    @datum_sources = DatumSource.all

    included = Category.all.map( &:as_jsonapi )
    included |= Group.all.map( &:as_jsonapi )

    render json: {
      data: @datum_sources.map( &:as_jsonapi ),
      included: included
    }
  end

end
