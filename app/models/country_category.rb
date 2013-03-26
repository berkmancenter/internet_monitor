class CountryCategory < ActiveRecord::Base
  belongs_to :country
  belongs_to :category
  attr_accessible :score

  def indicators
      Indicator.joins(:source).where(:country_id => country, :datum_sources => {:category_id => category})
  end
end
