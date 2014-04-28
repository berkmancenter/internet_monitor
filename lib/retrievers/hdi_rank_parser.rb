class HDIRankParser
  require 'csv'
  include Amatch

  def data(options = {})
    data = []
    filename = options[:filename]
    csv = CSV.read(filename, { :headers => true })
    csv.each do |row|
      country = Country.find_by_iso3_code(row['Abbreviation'])
      next unless country
      start_date = Date.new(2012, 1, 1)
      i = Indicator.new(:start_date => start_date, :original_value => row['2012 HDI rank'].to_f)
      i.country = country
      data << i
    end
    data
  end
end
