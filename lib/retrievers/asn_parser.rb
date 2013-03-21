class ASNParser
    require 'csv'

    def data(options = {})
        filename = options[:filename]
        column = options[:column]
        data = []
        csv = CSV.open(filename, { :headers => true })
        csv.each do |row|
            country = Country.find_by_iso_code(row['Code'])
            next unless country
            start_date = Date.new(2011, 1, 1)
            i = Indicator.new(:start_date => start_date, :original_value => row[column].to_f)
            i.country = country
            data << i
        end
        data
    end
end
