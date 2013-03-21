class DatumSource < ActiveRecord::Base
    attr_accessible :admin_name, :default_weight, :description, :for_infobox, :is_api, :link, :max, :min, :public_name, :retriever_class, :datum_type

    belongs_to :category
    has_many :data, :autosave => true
    has_one :ingester
    delegate :ingest_data!, :to => :ingester

    def retriever_class
        read_attribute(:retriever_class).constantize.new
    end

    def retreiver_class=(klass)
        write_attribute(:retriever_class, klass.name)
    end

    def recalc_min_max
        if datum_type == 'Indicator'
            temp_data = data.most_recent.map{|d| d.original_value } 
            puts admin_name
            puts temp_data.inspect
            self.min, self.max = temp_data.min, temp_data.max
        end
    end

    def recalc_all_values
        data.each{ |datum| datum.calc_value } if datum_type == 'Indicator'
    end

    def ingest_data!(options = {})
        self.data = retriever_class.data(options)
        self.datum_type = data.first.type
        logger.info %Q|Ingesting #{data.count} data from "#{public_name}"|
        recalc_min_max
        save!
        recalc_all_values
        save!
    end
end
