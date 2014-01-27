class CountryCategory < ActiveRecord::Base
  belongs_to :country
  belongs_to :category
  attr_accessible :score

  # calculate all category scores for all countries
  def self.calculate_scores!
    CountryCategory.all.each { |cc|
      ws = Indicator.weighted_score(cc.indicators.most_recent.affecting_score)
      cc.score = ws unless ws.nan?
      cc.save!
    }
  end

  def indicators
      Indicator.joins(:source).where(:country_id => country, :datum_sources => {:category_id => category})
  end
end
