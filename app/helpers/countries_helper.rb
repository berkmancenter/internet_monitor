module CountriesHelper
  def format_sidebar_value( datum )
    value = number_with_precision( datum.original_value, { precision: 0, delimiter: ',' } )
    value = "#{datum.source.display_prefix}#{value}#{datum.source.display_suffix}"
  end
end
