class GenderInequalityParser
    require 'roo'
    require 'csv'

    def data(options = {})
        filename = options[:filename]
        data = []
        csv = CSV.open(filename, { :headers => true })
        csv.each do |row|
            country = Country.find_by_name(row['Country'])
            next unless country

            # Get all quarterly cells
            row.select{|h,v| h.match(/\d{4}/) && v != '..'}.each do |header, value|
                start_date = Date.new(header.to_i, 1, 1)
                i = Indicator.new(:start_date => start_date, :original_value => value.to_f)
                i.country = country
                data << i
            end
        end
        data
    end
end
