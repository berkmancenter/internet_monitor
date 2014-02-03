class Country < ActiveRecord::Base
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
        where("indicator_count >= :min_indicators",
              {:min_indicators => Rails.application.config.imon['min_indicators']})
    scope :without_enough_data,
        where("indicator_count < :min_indicators",
              {:min_indicators => Rails.application.config.imon['min_indicators']})
    scope :desc_score, order('score DESC')

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
      indicator_count >= Rails.application.config.imon[ 'min_indicators' ]
    end

    def score(options = {})
        return read_attribute(:score) unless !options.empty?
        options.assert_valid_keys(:for)
        options.delete_if { |key, value| value.nil? }
        country_categories.where(:category_id => options[:for].id).first.score
    end

    def calculate_score!
      most_recent = indicators.most_recent.affecting_score
      self.indicator_count = most_recent.size
      ws = Indicator.weighted_score( most_recent )
      self.score = ws unless ws.nan?
      save!
    end

    private

    def indicators_affecting_score
        indicators.most_recent.affecting_score.order(:start_date)
    end

    def cache_key
      "c#{self.id}"
    end
end
