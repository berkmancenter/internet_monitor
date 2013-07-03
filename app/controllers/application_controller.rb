class ApplicationController < ActionController::Base
    protect_from_forgery
    before_filter :load_indicator_sources

    def load_indicator_sources
        @indicator_sources = DatumSource.where(:datum_type => 'Indicator')
    end
end
