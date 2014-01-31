class Datum < ActiveRecord::Base
    belongs_to :source, :class_name => 'DatumSource', :foreign_key => 'datum_source_id'
    belongs_to :country
    belongs_to :language
    attr_accessible :start_date, :value_id, :value, :original_value

    serialize :value
    serialize :original_value
    scope :for, lambda { |country_or_language|
        if country_or_language.is_a?(Country)
            where(:country_id => country_or_language.id)
        else
            where(:language_id => country_or_language.id)
        end
    }

    scope :indicators, joins( :source ).where( "datum_sources.datum_type = 'Indicator'" )
    scope :non_indicators, joins( :source ).where( "not datum_sources.datum_type = 'Indicator'" )

    scope :affecting_score, joins(:source).where(datum_sources: {affects_score: true})
    scope :most_recent, joins('INNER JOIN (SELECT MAX(d3.start_date) AS max_id, d3.datum_source_id, d3.country_id, d3.language_id FROM data AS d3 GROUP BY d3.datum_source_id, d3.country_id, d3.language_id) AS d2 ON (data.country_id = d2.country_id OR d2.language_id = data.language_id) AND data.datum_source_id = d2.datum_source_id AND data.start_date = d2.max_id')
    scope :in_category_page, joins(:source).where(datum_sources: {in_category_page: true})
    scope :in_sidebar, joins(:source).where(datum_sources: {in_sidebar: true})
    delegate :description, :to => :source

    def name
        source.public_name
    end
end
