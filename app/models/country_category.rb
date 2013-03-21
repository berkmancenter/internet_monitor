class CountryCategory < ActiveRecord::Base
  belongs_to :country
  belongs_to :category
  attr_accessible :score
end
