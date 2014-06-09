require 'csv'
class Retriever
    TYPE_MAP = {
        'number' => 'Indicator',
        'text' => 'HtmlBlock',
        'multiple URLs' => 'UrlList',
        'URL' => 'UrlList',
        'XML' => 'HtmlBlock',
        'HTML' => 'HtmlBlock',
        'JSON' => 'JsonObject'
    }

    def self.retrieve!(row_number)
        line = CSV.read(Rails.root.join('db', 'sources.csv'), :headers => true)[row_number.to_i - 1]
        puts "Retrieving #{line['Public name']}"

        ds = DatumSource.find_by_admin_name line['Short name']

        if ds.nil?
          puts "  creating DatumSource"
          ds = DatumSource.new(
              :admin_name => line['Short name'],
              :public_name => line['Public name'],
              :datum_type => TYPE_MAP[line['Data type']],
              :is_api => !line['API available?'].nil?,
              :source_name => line['Source (organization/study)'],
              :source_link => line['URL/source'],
              :retriever_class => line['Retriever Class'],
              :affects_score => line['Affects Score?'] == 'y',
              :display_original => line['Display Original Value?'] != 'n', # default to true unless explicitly 'n'
              :in_category_page => line['Include in Category Page?'] != 'n', # default to true unless explicitly 'n'
              :in_sidebar => line['Include in Sidebar?'] == 'y',
              :normalized => line['Normalized?'] == 'y', # default to false unless explicitly 'y' (DatumSource should have 'Normalized Column Name' field set)
              :display_prefix => line['Prefix'],
              :display_suffix => line['Suffix'],
              :precision => line['Precision'] || 0,
              :requires_page => line['Requires Page?'] == 'y',
              :default_weight => line['Default Weight'].to_f
          )
          ds.category = Category.find_by_name(line['Category'])
          ds.group = Group.find_by_admin_name(line['Group'])
          ds.save!
        end

        if line['Retriever Class']
            options = {}
            if line['Filename']
                options = {
                    :years => line['Year(s)'],
                    :filename => Rails.root.join('db', 'data_files', line['Filename']).to_s,
                    :sheetname => line['Sheet Name'],
                    :column => line['Column Name'],
                    :normalized_column => line['Normalized Column Name'],
                    :divide_by_gdp => line['Divide by GDP/cap?'] == 'y',
                    :append => line['Append'] == 'y'
                }
            end
            if line['Multiplier']
              puts "  multiply by #{line['Multiplier']}"
              options[ :multiplier ] = line['Multiplier'].to_f
            end
            options[ :retriever_class ] = line['Retriever Class']
            ds.ingest_data!(options)
        end

        GC.start
        puts "heap: #{GC.stat[ :heap_live_num ]}"
    end
end
