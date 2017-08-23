class Country < ActiveRecord::Base
    extend FriendlyId
    friendly_id :iso3_code, use: [:slugged, :finders]

    has_many :country_categories
    has_many :country_languages
    has_many :categories, :through => :country_categories
    has_many :languages, :through => :country_languages
    has_many :data
    has_many :indicators
    has_many :url_lists
    has_many :html_blocks
    has_many :images

    default_scope { where(:region => false) }

    scope :with_enough_data, -> {
        where("access_group_count >= :min_access_groups",
              {:min_access_groups => Rails.application.config.imon['min_access_groups']})
    }
    scope :without_enough_data, -> {
        where("access_group_count < :min_access_groups",
              {:min_access_groups => Rails.application.config.imon['min_access_groups']})
    }
    scope :desc_score, -> { order('score DESC') }

    def self.count_indicators!( index_name = Rails.application.config.imon[ 'current_index' ] )
      # moved from calculate_score because
      # we now need it beforehand to calc indicator min/max
      all.each { |country|
        current_indicators = country.indicators.in_index( index_name ).affecting_score
        country.indicator_count = current_indicators.count

        country.access_group_count = 0
        groups = []
        current_indicators.affecting_score.each { |i|
          if groups.index( i.source.group ).nil?
            country.access_group_count += 1
            groups << i.source.group
          end
        }
        country.save!
      }
    end

    def self.calculate_scores_and_rank!( index_name = Rails.application.config.imon[ 'current_index' ] )
      all.each { |country|
        country.calculate_score!( index_name )
      }

      with_enough_data.desc_score.each_with_index { | country, i |
        country.rank = i + 1
        country.save!
      }
    end

    def enough_data?
      access_group_count >= Rails.application.config.imon[ 'min_access_groups' ]
    end

    def calculate_score!( index_name )
      if !self.enough_data?
        self.update_attributes( score: nil )
        return
      end

      current_indicators = indicators.in_index( index_name ).affecting_score

      # group by datum_source group
      grouped = current_indicators.group_by { |i| i.source.group.admin_name }

      # calculate a weighted_score score for each group
      ws = 0
      grouped.each { |g|
        ws += Indicator.weighted_score( g[1] )
      }

      # average the group scores & multiply by max_score
      ws = ws / grouped.count * Rails.application.config.imon['max_score']

      self.score = ws unless ws.nan?
      save!
    end

    def as_jsonapi_v2
      {
        type: 'countries',
        id: id.to_s,
        attributes: {
          name: name,
          iso_code: iso_code,
          iso3_code: iso3_code
        },
        links: {
          self: ''
        },
        relationships: {
          data_points: {
            data: indicators.map( &:as_jsonapi_v2 )
          }
        }
      }
    end

    def as_jsonapi
      {
        type: 'countries',
        id: id.to_s,
        attributes: {
          name: name,
          iso_code: iso_code,
          iso3_code: iso3_code,
          score: score,
          rank: rank
        },
        links: {
          self: ''
        },
        relationships: {
          indicators: {
            data: indicators.in_current_index.map { |i|
              {
                type: 'indicators',
                id: i.id.to_s
              }
            }
          }
        }
      }
    end

    private

    def indicators_affecting_score
        indicators.in_current_index.affecting_score.order(:start_date)
    end

    def cache_key
      "c#{self.id}"
    end
end
