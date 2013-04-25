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
        # I should use duck-typing here
        return unless datum_type == 'Indicator'
        temp_data = data.most_recent.map{|d| d.original_value } 
        self.min, self.max = temp_data.min, temp_data.max
    end

    def recalc_all_values
        # I should use duck-typing here
        return unless datum_type == 'Indicator'
        data.each{ |datum| datum.calc_percent }
    end

    def ingest_data!(options = {})
        self.data = retriever_class.data(options)
        unless data.empty?
            self.datum_type = data.first.type
            logger.info %Q|Ingesting #{data.count} data from "#{public_name}"|
            if datum_type == 'Indicator'
                recalc_min_max
                save!
                recalc_all_values
            end
            save!
        end
    end
end
