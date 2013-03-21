class NetIndexParser
    require 'csv'

    def data(options = {})
        filename = options[:filename]
        column = options[:column]
        data = []
        csv = CSV.open(filename, { :headers => true })
        country_codes = csv.read['country_code'].uniq!
        csv.rewind
        country_codes.each do |code|
            country = Country.find_by_iso_code(code)
            next unless country
            csv.take_while{|row| row['country_code'] != code}
            rows = csv.take_while{|row| row['country_code'] == code}.reverse.take(30)
            start_date = Date.parse(rows[-1]['date'])
            value = rows.reduce(0.0){|sum, row| sum + row[column].to_f} / rows.count
            i = Indicator.new(:start_date => start_date, :original_value => value)
            i.country = country
            data << i
        end
        data
    end
end

