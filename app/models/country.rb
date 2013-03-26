class Country < ActiveRecord::Base
    attr_accessible :description, :iso3_code, :iso_code, :name, :score
    has_many :country_categories
    has_many :country_languages
    has_many :categories, :through => :country_categories
    has_many :languages, :through => :country_languages
    has_many :indicators

    def score(options = {})
        return read_attribute(:score) unless !options.empty?
        options.assert_valid_keys(:for)
        options.delete_if { |key, value| value.nil? }
        country_categories.where(:category_id => options[:for].id).first.score
    end

    def recalc_scores!
        ws = weighted_score(indicators.most_recent)
        self.score = ws unless ws.nan?
        country_categories.each do |cc|
            ws = weighted_score(cc.indicators.most_recent)
            cc.score = ws unless ws.nan?
            cc.save!
        end
        save!
    end

    private

    def weighted_score(indis)
        indis.reject!{|i| i.percent.nan?}
        sum = indis.reduce(0.0) do |sum, i|
            increment = i.percent * i.source.default_weight
            increment += 1.0 if i.source.default_weight < 0
            sum + increment
        end
        sum / indis.count.to_f * Rails.application.config.imon['max_score']
    end
end
