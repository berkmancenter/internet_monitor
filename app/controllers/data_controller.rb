class DataController < ApplicationController
    def show
        @datum = Datum.find(params[:id])
        respond_to do |format|
            format.html
            format.json
        end
    end

    def original
        @datum = Datum.find(params[:id])
        respond_to do |format|
            format.json { render :text => @datum.original_value }
        end
    end
end
