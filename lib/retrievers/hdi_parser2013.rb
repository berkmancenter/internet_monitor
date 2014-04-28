class HDIParser2013
    require 'csv'
    include Amatch

    def data(options = {})
        data = []
        filename = options[:filename]
        csv = CSV.read(filename, { :headers => true })
        csv.each do |row|
            country = Country.find_by_iso3_code(row['Abbreviation'])
            next unless country
            ['2012'].each do |year|
                column = "#{year} HDI Value"
                next if row[column] == '..'
                start_date = Date.new(year.to_i, 1, 1)
                i = Indicator.new(:start_date => start_date, :original_value => row[column].to_f)
                i.country = country
                data << i
            end
        end
        data
    end
end
