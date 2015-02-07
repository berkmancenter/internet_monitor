require 'open-uri'

class DatumSourcesController < ApplicationController
  def index
    if params[:type]
      @datum_sources = DatumSource.where(:datum_type => params[:type])
    else
      @datum_sources = DatumSource.all
    end
    respond_to do |format|
      format.html
      format.any(:json, :xml)
    end
  end

  def show
    @datum_source = DatumSource.find(params[:id])

    if @datum_source.is_api?
      respond_to do |format|
        endpoint = open @datum_source.api_endpoint
        format.xml {
          render xml: endpoint.read
        }
        format.json {
          render json: endpoint.read
        }
      end
    else
      not_found
    end
  end
end
