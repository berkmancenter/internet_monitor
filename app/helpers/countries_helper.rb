module CountriesHelper
  def update_content( iso3_code )
    content = part_content( iso3_code, :body )
    if content.nil?
      content = part_content( 'zzz-countries', :body )
    end
    content
  end
  
  def format_sidebar_value( datum )
    value = number_with_precision( datum.original_value, { precision: datum.source.precision || 0, delimiter: ',' } )
    value = "#{datum.source.display_prefix}#{value}#{datum.source.display_suffix}"
  end
end
