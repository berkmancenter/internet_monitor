class Category < ActiveRecord::Base
    has_many :datum_sources
    has_many :data, through: :datum_sources

    extend FriendlyId
    friendly_id :name, :use => :slugged

    def as_jsonapi
      {
        type: 'categories',
        id: id.to_s,
        attrributes: {
          name: name,
          slug: slug
        }
      }
    end
end
