class Region < Country
  self.table_name = 'countries'

  default_scope where(:region => true)

  def as_jsonapi
    {
      type: 'regions',
      id: id.to_s,
      attributes: {
        name: name,
        iso3_code: iso3_code
      },
      links: {
        self: ''
      },
      relationships: {
        indicators: {
          data: indicators.in_current_index.map { |i|
            {
              type: 'indicators',
              id: i.id.to_s
            }
          }
        }
      }
    }
  end
end
