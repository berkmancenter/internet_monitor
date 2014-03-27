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
        ds = DatumSource.new(
            :admin_name => line['Short name'],
            :public_name => line['Public name'],
            :datum_type => TYPE_MAP[line['Data type']],
            :is_api => !line['API available?'].nil?,
            :source_name => line['Source (organization/study)'],
            :source_link => line['URL/source'],
            :retriever_class => line['Retriever Class'],
            :affects_score => line['Affects Score?'] == 'y',
            :in_category_page => line['Include in Category Page?'] != 'n', # default to true unless specifically 'n'
            :in_sidebar => line['Include in Sidebar?'] == 'y',
            :display_prefix => line['Prefix'],
            :display_suffix => line['Suffix'],
            :precision => line['Precision'] || 0,
            :requires_page => line['Requires Page?'] == 'y',
            :default_weight => line['Default Weight'].to_f
        )
        ds.category = Category.find_by_name(line['Category'])
        ds.group = Group.find_by_admin_name(line['Group'])
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
