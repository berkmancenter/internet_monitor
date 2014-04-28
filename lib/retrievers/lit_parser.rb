class LitParser
  require 'csv'

  def data(options = {})
    filename = options[:filename]
    data = []
    spreadsheet = Roo::Spreadsheet.open(filename)
    csv = CSV.open filename, { headers: true }
    csv.each do |row|
      country = Country.find_by_name row['Country or Area']
      next unless country

      i = Indicator.new( {
        start_date: Date.new(2011, 1, 1),
        original_value: row[ 'Value' ].to_f
      } )
      i.country = country
      data << i
    end
    data
  end
end
