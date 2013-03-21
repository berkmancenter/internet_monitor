class CountryLanguage < ActiveRecord::Base
  belongs_to :country
  belongs_to :language
  # attr_accessible :title, :body
end
