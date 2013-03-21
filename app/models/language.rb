class Language < ActiveRecord::Base
  attr_accessible :iso_code, :name
  has_many :data
end
