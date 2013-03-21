class ITUParser
    require 'roo'
    require 'csv'

    def data(options = {})
        filename = options[:filename]
        data = []
        spreadsheet = Roo::Spreadsheet.open(filename)
        #gdp_spreadsheet = Roo::Spreadsheet.open(Rails.root.join('db', 'data_files', 'ny.gdp.pcap.cd_Indicator_MetaData_en_EXCEL.xls').to_s)
        #gdp_csv = CSV.parse(gdp_spreadsheet.sheet(0).to_csv, { :headers => true })
        csv = CSV.parse(spreadsheet.sheet(0).to_csv, { :headers => true })
        csv.each do |row|
            country = Country.find_by_iso3_code(row['Country Code'])
            next unless country
            #country_gdp = gdp_csv.find{|row| row['Country Code'] == country.iso3_code}.select{|h, v| h.match(/\d{4}/) && !v.nil?}.reverse.first[1]

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

