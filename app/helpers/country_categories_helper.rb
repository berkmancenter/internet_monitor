module CountryCategoriesHelper
  def indicators_partial( group )
    # return the correct partial to render for a given indicator group
    if group.admin_name == 'filtering'
      'data/indicators_filtering'
    elsif group.admin_name == 'filtering_mo'
      'data/indicators_filtering_mo'
    else
      'data/indicators'
    end
  end
end
