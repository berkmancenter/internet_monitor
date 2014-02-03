class DataController < ApplicationController
  def show
    @datum = Datum.find(params[:id])
    respond_to do |format|
      format.json
    end
  end
end
