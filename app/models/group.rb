class Group < ActiveRecord::Base
  attr_accessible :admin_name, :public_name

  has_many :datum_sources
end
