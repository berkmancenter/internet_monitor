class Country < ActiveRecord::Base
    extend FriendlyId
    friendly_id :iso3_code, :use => :slugged

    attr_accessible :description, :iso3_code, :iso_code, :name, :indicator_count, :score, :rank
    has_many :country_categories
    has_many :country_languages
    has_many :categories, :through => :country_categories
    has_many :languages, :through => :country_languages
    has_many :data
    has_many :indicators
    has_many :url_lists
    has_many :html_blocks
    has_many :images

    scope :with_enough_data,
        where("access_group_count >= :min_access_groups",
              {:min_access_groups => Rails.application.config.imon['min_access_groups']})
    scope :without_enough_data,
        where("access_group_count < :min_access_groups",
              {:min_access_groups => Rails.application.config.imon['min_access_groups']})
    scope :desc_score, order('score DESC')

    def self.count_indicators!
      # moved from calculate_score because
      # we now need it beforehand to calc indicator min/max
      all.each { |country|
        most_recent = country.indicators.most_recent.affecting_score
        country.indicator_count = most_recent.size

        country.access_group_count = 0
        groups = []
        most_recent.each { |i|
          if groups.index( i.source.group ).nil?
            country.access_group_count += 1
            groups << i.source.group
          end
        }
        country.save!
      }
    end

    def self.calculate_scores_and_rank!
      all.each { |country|
        country.calculate_score!
      }

      with_enough_data.desc_score.each_with_index { | country, i |
        country.rank = i + 1
        country.save!
      }
    end

    def enough_data?
      access_group_count >= Rails.application.config.imon[ 'min_access_groups' ]
    end

    def calculate_score!
      return unless self.enough_data?

      most_recent = indicators.most_recent.affecting_score

      # group by datum_source group
      grouped = most_recent.group_by { |i| i.source.group.admin_name }

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

    def as_jsonapi
      {
        type: 'countries',
        id: id.to_s,
        attributes: {
          name: name,
          iso_code: iso_code,
          iso3_code: iso3_code,
          score: score
        },
        links: {
          self: ''
        },
        relationships: {
          indicators: {
            data: indicators.map { |i|
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
        indicators.most_recent.affecting_score.order(:start_date)
    end

    def cache_key
      "c#{self.id}"
    end
end
