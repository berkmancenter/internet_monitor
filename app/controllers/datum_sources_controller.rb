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
    respond_to do |format|
      format.json
    end
  end

end
