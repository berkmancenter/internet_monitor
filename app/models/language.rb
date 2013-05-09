class Language < ActiveRecord::Base
    attr_accessible :iso_code, :name
    has_many :data
    has_many :country_languages
    has_many :countries, :through => :country_languages
    has_many :indicators
    has_many :url_lists
    has_many :html_blocks
    has_many :images
end
