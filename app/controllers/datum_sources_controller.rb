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
end
