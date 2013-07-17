module DataHelper
    def retriever_class_name(datum)
        datum.source.retriever_class.class.name.underscore.dasherize
    end
end
