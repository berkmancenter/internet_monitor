class Provider < ActiveRecord::Base
  attr_accessible :name, :short_name, :url

  has_many :datum_sources
end
