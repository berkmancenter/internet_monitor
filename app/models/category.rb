class Category < ActiveRecord::Base
    attr_accessible :name

    has_many :datum_sources
    has_many :data, through: :datum_sources

    extend FriendlyId
    friendly_id :name, :use => :slugged
end
