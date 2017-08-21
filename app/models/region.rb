class Region < Country
  self.table_name = 'countries'

  default_scope where(:region => true)

  scope :with_enough_data, -> { where('indicator_count > 0') }
  scope :without_enough_data, -> { where('indicator_count = 0') }
  scope :desc_score, -> { order('score DESC') }

  def enough_data?
    indicator_count > 0
  end

  def as_jsonapi
    {
      type: 'regions',
      id: id.to_s,
      attributes: {
        name: name,
        iso3_code: iso3_code,
        score: score,
        rank: rank
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
