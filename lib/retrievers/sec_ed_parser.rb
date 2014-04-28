class SecEdParser
  require 'csv'

  def data(options = {})
    sheetname = options[:sheetname]
    column = options[:column]
    filename = options[:filename]
    data = []
    csv = CSV.open filename, { headers: true }
    csv.each do |row|
      country = Country.find_by_iso3_code row['Country Code']
      next unless country
      next if row[column] == '..'

      i = Indicator.new( {
        start_date: Date.new(2010, 1, 1),
        original_value: row[ column ].to_f
      } )
      i.country = country
      data << i
    end
    data
  end
end
