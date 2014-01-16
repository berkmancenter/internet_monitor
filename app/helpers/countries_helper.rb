module CountriesHelper
  def format_sidebar_value( datum )
    value = number_with_precision( datum.original_value, { precision: 0, delimiter: ',' } )

    if datum.source.public_name.include?( 'GDP' )
      value = "$#{value}"
    else
      value
    end
  end
end
