class Datum < ActiveRecord::Base
    belongs_to :source, :class_name => 'DatumSource', :foreign_key => 'datum_source_id'
    belongs_to :country
    belongs_to :language
    attr_accessible :start_date, :value, :original_value

    serialize :value
    scope :for, lambda { |country| where(:country => country) }
    delegate :description, :to => :source

    def name
        source.public_name
    end

    def self.most_recent
         joins('INNER JOIN (SELECT MAX(`d3`.`start_date`) AS max_id, `d3`.`datum_source_id`, `d3`.`country_id` FROM `data` as d3 GROUP BY d3.datum_source_id, d3.country_id) as d2 on data.country_id = d2.country_id and data.datum_source_id = d2.datum_source_id and data.start_date = d2.max_id')
    end
end
