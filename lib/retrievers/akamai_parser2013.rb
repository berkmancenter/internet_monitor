class AkamaiParser2013
    require 'roo'
    require 'csv'
    QUARTER_MAP = {
        'Q1' => [1, 1],
        'Q2' => [4, 1],
        'Q3' => [7, 1],
        'Q4' => [10, 1]
    }

    # all floats
    # map country name to country code
    # convert "Q\d \d\d\d\d" to latest date
    
    def data(options = {})
        sheetname = options[:sheetname]
        column = options[:column]
        filename = options[:filename]

        data = []

        spreadsheet = Roo::Spreadsheet.open(filename)

        csv = CSV.parse(spreadsheet.sheet(sheetname).to_csv, { :headers => true })

        csv.each do |row|
            country = Country.find_by_name(row['Region'])
            next unless country

            # Get all quarterly cells
            #row.select{|h,v| h.match(/Q\d \d{4}/)}.each do |header, value|
            quarter, year = *sheetname.split(' ')
            start_date = Date.new(year.to_i, QUARTER_MAP[quarter][0], QUARTER_MAP[quarter][1])
            value = row[ column ]
            i = Indicator.new(:start_date => start_date, :original_value => value.to_f)
            i.country = country
            data << i
            #end
        end
        data
    end
end

