class DatumSource < ActiveRecord::Base
    attr_accessible :admin_name, :default_weight, :description, :display_original, :in_category_page, :in_sidebar, :requires_page, :normalized, :is_api, :source_name, :source_link, :max, :min, :public_name, :retriever_class, :datum_type, :affects_score, :display_prefix, :display_suffix, :precision, :multiplier, :normalized_name, :invert

    belongs_to :category
    belongs_to :group

    has_many :data, :autosave => true, :dependent => :delete_all
    has_one :ingester
    delegate :ingest_data!, :to => :ingester

    scope :are_api, -> {
      where( is_api: true )
    }

    scope :only_indicators, -> {
      where( datum_type: 'Indicator' )
    }

    def self.recalc_ds!( id, index_name )
      ds = find id
      Rails.logger.info "Recalculating #{ ds.admin_name }"

      ds.recalc_min_max index_name
      ds.save!
      ds.recalc_all_values
    end

    def self.recalc_min_max_and_values!( index_name = Rails.application.config.imon[ 'current_index' ] )
      ds_ids = select :id

      ds_ids.each { |ds|
        t = Thread.new { recalc_ds! ds.id, index_name }
        t.join

        GC.start
      }
    end

    def retriever_class( option_class = nil )
      rc = read_attribute(:retriever_class)

      if option_class.present?
        rc = option_class
      end

      rc.constantize.new
    end

    def retreiver_class=(klass)
      # TODO: this function name is spelled wrong
      # but I don't dare chagnge it now because the site works
        write_attribute(:retriever_class, klass.name)
    end

    def recalc_min_max( index_name )
        # I should use duck-typing here
        return unless datum_type == 'Indicator'
        country_ids = Country.with_enough_data.map { |c| c.id }
        current_indicators = data.in_index( index_name ).where( { country_id: country_ids } )
        temp_data = current_indicators.map{|d| d.original_value } 
        self.min, self.max = temp_data.min, temp_data.max
    end

    def recalc_all_values
        # I should use duck-typing here
        return unless datum_type == 'Indicator' && min.present? && max.present?
        data.each { |datum|
          datum.calc_percent
          datum.save
        }
    end

    def ingest_data!(options = {}, datum = nil)
      if datum.present?
        datum.value = retriever_class( options[ :retriever_class ] ).data(options, datum.country)
        datum.save
      else
        if options[ :append ]
          self.data << retriever_class( options[ :retriever_class ] ).data(options)
        else
          self.data = retriever_class( options[ :retriever_class ] ).data(options)
        end

        save!
        unless data.empty?
            self.datum_type = data.first.type
            logger.info %Q|Ingested #{data.count} data from "#{options[ :retriever_class ]}"|
            save!
        end
      end
    end

    def as_jsonapi
      {
        type: 'datum_sources',
        id: id.to_s,
        attributes: {
          admin_name: admin_name,
          public_name: public_name,
          short_name: short_name,
          description: description,
          min: min,
          max: max,
          default_weight: default_weight,
          affects_score: affects_score,
          source_name: source_name,
          source_link: source_link,
          display_class: display_class,
          display_prefix: display_prefix,
          display_suffix: display_suffix,
          precision: precision
        },
        relationships: {
          category: {
            data: ( category.present? ? {
              type: 'categories',
              id: category.id.to_s
            } : nil )
          },
          group: {
            data: ( group.present? ? {
              type: 'groups',
              id: group.id.to_s
            } : nil )
          }
        }
      }
    end
end
