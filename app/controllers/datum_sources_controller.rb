require 'open-uri'

class DatumSourcesController < ApplicationController
  before_filter :set_datum_source, only: [:show, :edit, :update, :destroy]

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

  # GET /datum_sources/1
  def show
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

  # GET /datum_sources/1/edit
  def edit
  end

  # PATCH/PUT /datum_sources/1
  def update
    if @datum_source.update(datum_source_params)
      redirect_to datum_sources_path
    else
      render action: 'edit'
    end
  end


  private

  def set_datum_source
    @datum_source = DatumSource.find(params[:id])
  end

  def datum_source_params
    params.require(:datum_source).permit(:admin_name, :public_name, :description, :min, :max, :default_weight, :affects_score, :source_name, :display_prefix, :display_suffix, :precision, :normalized)
  end
end
