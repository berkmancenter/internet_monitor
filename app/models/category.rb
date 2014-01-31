class Category < ActiveRecord::Base
    attr_accessible :name
    has_many :datum_sources
    has_many :data, through: :datum_sources
    #has_many :url_lists
    #has_many :indicators
    #has_many :images
    #has_many :html_blocks

    extend FriendlyId
    friendly_id :name, :use => :slugged
end
