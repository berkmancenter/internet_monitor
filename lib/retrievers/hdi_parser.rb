class HDIParser
    require 'csv'
    include Amatch

    def data(options = {})
        data = []
        filename = options[:filename]
        csv = CSV.read(filename, { :headers => true })
        csv.each do |row|
            country = Country.find_by_iso3_code(row['ISO Code'])
            next unless country
            ['1980','1990','2000','2005','2009','2010','2011'].each do |year|
                next if row[year] == '..'
                start_date = Date.new(year.to_i, 1, 1)
                i = Indicator.new(:start_date => start_date, :original_value => row[year].to_f)
                i.country = country
                data << i
            end
        end
        data
    end
end
