class Provider < ActiveRecord::Base
  attr_accessible :name, :short_name, :url
end
