class LitParser
  require 'csv'

  def data(options = {})
    filename = options[:filename]
    multiplier = options[:multiplier] || 1.0
    data = []
    csv = CSV.open filename, { headers: true }
    csv.each do |row|
      country = Country.find_by_name row['Country']
      next unless country

      i = Indicator.new( {
        start_date: Date.new(2014, 6, 12),
        original_value: row[ 'Literacy rate' ].to_f * multiplier
      } )
      i.country = country
      data << i
    end
    data
  end
end
