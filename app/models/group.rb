class Group < ActiveRecord::Base
  attr_accessible :admin_name, :public_name

  has_many :datum_sources

  def as_jsonapi
    {
      type: 'groups',
      id: id.to_s,
      attrributes: {
        admin_name: admin_name,
        public_name: public_name,
        default_weight: default_weight
      }
    }
  end
end
