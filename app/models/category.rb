class Category < ActiveRecord::Base
    attr_accessible :name
    has_many :datum_sources
    has_many :url_lists, :through => :datum_sources
    has_many :indicators, :through => :datum_sources
    has_many :images, :through => :datum_sources
    has_many :html_blocks, :through => :datum_sources
    #has_many :people, :through => :widget_groupings, :conditions => { :type => 'Person' }, :source => :grouper, :source_type => 'SentientBeing'
    #has_many :aliens, :through => :widget_groupings, :conditions => { :type => 'Alien' }, :source => :grouper, :source_type => 'SentientBeing'
end
