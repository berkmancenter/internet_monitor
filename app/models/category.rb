class Category < ActiveRecord::Base
    attr_accessible :name
    has_many :url_lists
    has_many :indicators
    has_many :images
    has_many :html_blocks
    #has_many :people, :through => :widget_groupings, :conditions => { :type => 'Person' }, :source => :grouper, :source_type => 'SentientBeing'
    #has_many :aliens, :through => :widget_groupings, :conditions => { :type => 'Alien' }, :source => :grouper, :source_type => 'SentientBeing'
end
