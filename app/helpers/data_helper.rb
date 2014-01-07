module DataHelper
  def retriever_class_name(datum)
    datum.source.retriever_class.class.name.underscore.dasherize
  end

  def refinery_page( datum )
    Refinery::Page.by_slug( "#{datum.source.admin_name}_#{datum.value_id}" )
  end
end
