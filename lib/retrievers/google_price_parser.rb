class GooglePriceParser
  require 'csv'

  def data(options = {})
    years = options[:years]
    filename = options[:filename]
    column = options[:column]
    normalized_column = options[:normalized_column]
    multiplier = options[:multiplier] || 1.0
    data = []
    csv = CSV.open(filename, { :headers => true })
    csv.each do |row|
      country = Country.find_by_name(row['Country'])
      next unless country

      start_date = Date.new(years.to_i, 1, 1)
      datum = row[column].to_f * multiplier unless row[column].nil?
      normalized = row[normalized_column].to_f unless row[normalized_column].nil?
      unless datum.nil?
        i = Indicator.new(:start_date => start_date, :original_value => datum, :value => normalized)
        i.country = country
        data << i
      end
    end
    data
  end
end

