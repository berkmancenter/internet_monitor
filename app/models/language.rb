class Language < ActiveRecord::Base
    has_many :data
    has_many :country_languages
    has_many :countries, :through => :country_languages
    has_many :indicators
    has_many :url_lists
    has_many :html_blocks
    has_many :images
end
