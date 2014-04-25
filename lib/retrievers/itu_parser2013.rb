class ITUParser2013
    require 'csv'

    def data(options = {})
        filename = options[:filename]
        data = []
        divide_by_gdp = options[:divide_by_gdp]
        if divide_by_gdp
            gdp_csv = CSV.open(Rails.root.join('db', 'data_files', Rails.application.config.imon["gdp_data_file"]), { :headers => true })
        end
        csv = CSV.open(filename, { :headers => true })
        csv.each do |row|
            country = Country.find_by_iso3_code(row['Country Code'])
            next unless country
            if divide_by_gdp
                gdp_csv.rewind
                gdp_row = gdp_csv.find{|row| row['Country Code'] == country.iso3_code}
                next if gdp_row.nil?
                gdps = gdp_row.select{|h, v| h.match(/\d{4}/) && !v.nil?}
                next if gdps.empty?
                country_gdp_per_cap = gdps.reverse.first[1]
            end
            # Get all quarterly cells
            row.select{|h,v| h.match(/\d{4}/) && v != '..'}.each do |header, value|
                start_date = Date.new(header.to_i, 1, 1)
                value = value.to_f / country_gdp_per_cap.to_f if divide_by_gdp
                i = Indicator.new(:start_date => start_date, :original_value => value.to_f)
                i.country = country
                data << i
            end
        end
        data
    end
end

