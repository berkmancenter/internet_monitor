class V1::CountriesController < ApplicationController
  def index
    @scored_countries = Country.with_enough_data.desc_score

    render json: {
      data: @scored_countries.limit(1).map { |sc|
        {
          type: 'countries',
          id: sc.id.to_s,
          attributes: {
            name: sc.name,
            iso_code: sc.iso_code,
            iso3_code: sc.iso3_code,
            score: sc.score
          },
          links: {
            self: country_url( sc )
          },
          relationships: {
            indicators: {
              data: sc.indicators.map { |i|
                {
                  type: 'indicators',
                  id: i.id.to_s
                }
              }
            }
          }
        }
      },
      included: @scored_countries.first.indicators.map { |i|
        {
          type: 'indicators',
          id: i.id.to_s,
          attributes: {
            original_value: i.original_value,
            value: i.value
          },
          relationships: {
            datum_source: {
              data: {
                type: 'datum_sources',
                id: i.source.id.to_s
              }
            }
          }
        }
      }
    }
  end

  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.any(:json)
    end
  end

end
