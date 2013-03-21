class WorldBankParser
    require 'roo'
    require 'csv'

    def data(options = {})
        filename = options[:filename]
        data = []
        spreadsheet = Roo::Spreadsheet.open(filename)
        csv = CSV.parse(spreadsheet.sheet(0).to_csv, { :headers => true })
        csv.each do |row|
            country = Country.find_by_iso3_code(row['Country Code'])
            next unless country

            # Get all quarterly cells
            row.select{|h,v| h.match(/\d{4}/) && !v.nil? }.each do |header, value|
                start_date = Date.new(header.to_i, 1, 1)
                i = Indicator.new(:start_date => start_date, :original_value => value.to_f)
                i.country = country
                data << i
            end
        end
        data
    end
end
