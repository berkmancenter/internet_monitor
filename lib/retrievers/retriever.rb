require 'csv'
class Retriever
    def self.retrieve!(row_number)

        type_map = {
            'number' => 'quantitative',
            'text' => 'html',
            'multiple URLs' => 'url_list',
            'URL' => 'url_list',
            'XML' => 'html'
        }

        line = CSV.read(Rails.root.join('db', 'sources.csv'), :headers => true)[row_number.to_i - 1]
        ds = DatumSource.new(
            :admin_name => line['Indicator'],
            :public_name => line['Indicator'],
            :datum_type => type_map[line['Data type']],
            :is_api => !line['API available?'].nil?,
            :retriever_class => line['Retriever Class'],
            :default_weight => line['Default Weight'].to_f
        )
        ds.category = Category.find_by_name(line['Category'])
        ds.save!
        if line['Retriever Class']
            options = {}
            if line['Filename']
                options = {
                    :filename => Rails.root.join('db', 'data_files', line['Filename']).to_s,
                    :sheetname => line['Sheet Name'],
                    :column => line['Column Name'],
                    :divide_by_gdp => line['Divide by GDP/cap?'] == 'y'
                }
            end
            ds.ingest_data!(options)
        end
    end
end
