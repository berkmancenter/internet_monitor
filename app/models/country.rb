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
        self.score = indicators.most_recent.reduce(0.0){|sum, i| sum + (i.value * i.source.default_weight)} / indicators.most_recent.reduce(0.0){|sum, i| sum + i.source.default_weight}
        # country_categories.each do |cc|
        #     cc.score = 
        # end
        save!
    end
end
