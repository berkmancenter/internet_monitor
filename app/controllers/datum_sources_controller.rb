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

  # GET /datum_sources/new
  def new
    @datum_source = DatumSource.new
  end
  
  # GET /datum_sources/1/edit
  def edit
  end

  # POST /datum_sources
  def create
    @datum_source = DatumSource.new(params[:datum_source])

    if @datum_source.save
      redirect_to datum_sources_path, notice: 'Datum Source was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /datum_sources/1
  def update
    if @datum_source.update_attributes(params[:datum_source])
      redirect_to datum_sources_path, notice: 'Datum Source was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /datum_sources/1
  def destroy
    @datum_source.destroy
    redirect_to datum_sources_path
  end

  private

  def set_datum_source
    @datum_source = DatumSource.find(params[:id])
  end
end
