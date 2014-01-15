class HDIRankParser
  require 'csv'
  include Amatch

  def data(options = {})
    data = []
    filename = options[:filename]
    csv = CSV.read(filename, { :headers => true })
    csv.each do |row|
      country = Country.find_by_iso3_code(row['ISO Code'])
      next unless country
      start_date = Date.new(2011, 1, 1)
      i = Indicator.new(:start_date => start_date, :original_value => row['Rank (2011)'].to_f)
      i.country = country
      data << i
    end
    data
  end
end
