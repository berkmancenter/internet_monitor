require 'csv'

namespace :imon do
  desc 'Ingest data from individual source, do not recalculate all'
  task :ingest, [:row_number] => [:environment] do |task, args|
    Retriever.retrieve!(args[:row_number])

#    puts 'Country.count_indicators'
#    Country.count_indicators!
#
#    puts 'DatumSource.recalc_min_max_and_values!'
#    DatumSource.recalc_min_max_and_values!
#
#    puts 'Country.calculate_scores_and_rank!'
#    Country.calculate_scores_and_rank!
  end

  desc 'Export most recent data for all countries'
  task :export_most_recent, [:filename] => [:environment] do |task, args|
    export_most_recent args[:filename]
  end

  desc 'Import country bboxes'
  task :import_country_bboxes, [:filename] => [:environment] do |task, args|
    import_country_bboxes args[:filename]
  end

  desc 'Replace most recent static (HTML/JSON) source for country'
  task :replace_static_source, [:row_number, :iso3_code] => [:environment] do |task, args|
    replace_static_source args[ :row_number ], args[ :iso3_code ]
  end

  desc 'Migrate country profile pages in RefineryCMS to be the correct names'
  task :migrate_country_profiles_081 => [:environment] do |task|
    Rails.logger.info '[mcp] start migrate_country_profiles_081'

    mcp_081

    Rails.logger.info '[mcp] end migrate_country_profiles_081'
  end

  desc 'Extract widget embeds from a dasboard page to a country page in refinery'
  task :import_country_widgets => [:environment] do |task|
    Rails.logger.info '[icw] start import_country_widgets'


    # On IM Dashboard, run this in Dev Tools to get third parameter
    # JSON.stringify( $( '.widget' ).map( function( ) { let widget = $(this); return { mid: widget.data( 'mid' ), cx: widget.data( 'sizex' ), cy: widget.data( 'sizey' ), row: widget.data( 'row' ), col: widget.data( 'col' ) } } ).toArray() )
    countries = [
      [ 'kaz', 'gZFsACAZfBepxcamb', %|[{"mid":"as3afWnHaREGfZJoi","cx":2,"cy":1,"row":5,"col":1},{"mid":"DwQXyfRWBfDy94T9A","cx":2,"cy":1,"row":4,"col":1},{"mid":"euG9ynkSAs4MNzdtg","cx":2,"cy":1,"row":4,"col":3},{"mid":"Hy5uwhLkXJM4zYpFb","cx":2,"cy":1,"row":5,"col":3},{"mid":"MiZMvP6ESQLhTWHqc","cx":2,"cy":1,"row":2,"col":1},{"mid":"qEunRWcmJ8XFp2c4w","cx":2,"cy":1,"row":2,"col":3},{"mid":"SnSgTBzz723rmnRKz","cx":2,"cy":2,"row":6,"col":1}]| ],
      [ 'pak', '8B7gFN4sPiPr7ND46', %|[{"mid":"xA9e8NdwNKZsGERr3","cx":3,"cy":1,"row":1,"col":2},{"mid":"f4DgFjPzFXtMdPxk4","cx":3,"cy":1,"row":3,"col":1},{"mid":"o4npp5NaKaQTMPsKg","cx":2,"cy":1,"row":2,"col":1},{"mid":"omGmyNjWmRB5mFGYt","cx":2,"cy":1,"row":2,"col":3},{"mid":"dk47NTgEqwHWDkyKf","cx":2,"cy":2,"row":6,"col":1},{"mid":"DE3wkscwe9fX95tE4","cx":2,"cy":1,"row":4,"col":3},{"mid":"44ShiGEX8HTo4ymGK","cx":2,"cy":1,"row":4,"col":1},{"mid":"z6iPW5KbeGuXprwA8","cx":2,"cy":1,"row":5,"col":1},{"mid":"siwNfrdPhuL2iQ27E","cx":2,"cy":1,"row":5,"col":3}]| ],
      [ 'arm', 'dBiFBajZoKS3qzvpZ', %|[{"mid":"RhpeeJzGNDnkAdPSF","cx":2,"cy":1,"row":7,"col":1},{"mid":"iTZbGBRtMCKBKJisx","cx":2,"cy":1,"row":7,"col":3},{"mid":"7dDZAhFxo2aY8YoJS","cx":2,"cy":1,"row":6,"col":3},{"mid":"oGACpJygB2zp5mXXC","cx":2,"cy":1,"row":6,"col":1},{"mid":"SAKb7wXFcuZw4j22g","cx":4,"cy":1,"row":3,"col":1},{"mid":"SCCqrpQ5qrwspS92g","cx":4,"cy":1,"row":5,"col":1},{"mid":"YrXKHTuJLZ2mET6QK","cx":2,"cy":1,"row":4,"col":3},{"mid":"oYSnsYwQQgNXpKm7i","cx":2,"cy":1,"row":4,"col":1},{"mid":"X8DJZnAJsaiPZ4swq","cx":2,"cy":2,"row":8,"col":1},{"mid":"79xR3yEKWhhQr9N3i","cx":4,"cy":2,"row":1,"col":1}]| ],
      [ 'aze', 'bbvtxnwKxG3wXRPaG', %|[{"mid":"it7B3ftnwbMuRwaBf","cx":2,"cy":1,"row":7,"col":1},{"mid":"tL7nr6dEjaRC4uiRG","cx":2,"cy":1,"row":7,"col":3},{"mid":"vWbH8dM7sCYTvYLuH","cx":2,"cy":1,"row":6,"col":3},{"mid":"6iTzfz36vbZe4Mocd","cx":2,"cy":1,"row":6,"col":1},{"mid":"78krbpebfuyTTyuPJ","cx":4,"cy":1,"row":3,"col":1},{"mid":"Ch3nQSHx9KdEEBgBL","cx":4,"cy":1,"row":5,"col":1},{"mid":"fRqgJTLrSPRNdZrQY","cx":2,"cy":1,"row":4,"col":3},{"mid":"dthDzt7CfJHwscAYR","cx":2,"cy":1,"row":4,"col":1},{"mid":"gRbwkuES4d95MPEge","cx":2,"cy":2,"row":8,"col":1},{"mid":"wJkS6Pb3aK6Krub6y","cx":4,"cy":2,"row":1,"col":1}]| ]
    ]

    country_page_parent = Refinery::Page.find_by_slug '2016-annual-report'

    countries.each { |c|
      Rails.logger.info "[icw] country: #{c[0]}"
      country_page = country_page_parent.children.find_by_slug c[0]

      if country_page.nil?
        Rails.logger.info "[icw] creating page for #{c[0]}"

        country = Country.find_by_iso3_code c[0].upcase
        if country.nil?
          Rails.logger.error "[icw] cannot find country for #{c[0]}"
        else
          country_page = country_page_parent.children.create title: country.name, menu_title: country.iso3_code, layout_template: 'report_country'
        end
      end

      widget_dscs = JSON.parse c[2]
      widget_dscs = widget_dscs.sort_by { |wdsc| [ wdsc[ 'row' ], wdsc[ 'col' ] ] }
      import_country_widgets country_page, c[1], widget_dscs
    }

    Rails.logger.info '[icw] end import_country_widgets'
  end

  desc 'Setup original 2014 index and migrate indicator admin_names'
  task :migrate_indicators_2015 => [:environment] do |task|
    if Indicator.in_index( '2014' ).count == 0
      Indicator.update_all( index_name: 'ARCHIVE' )
      Indicator.most_recent.update_all( index_name: '2014' )
    end

    admin_names = {
      'inet' => 'ipr',
      'net' => 'hhnet',
      'wisr' => 'bbsub',
      'mbsr' => 'mobilebb',
      'bbar' => 'bbrate',
      'hbbar' => 'highbbrate',
      'acsp' => 'speedkbps',
      'apcsp' => 'peakspeedkbps',
      'adsp' => 'downloadkbps',
      'ausp' => 'uploadkbps',
      'bbpt1' => 'bbcost1',
      'bbpt2' => 'bbcost2',
      'bbpt3' => 'bbcost3',
      'bbpt4' => 'bbcost4',
      'bbpt5' => 'bbcost5',
      'bbpai' => 'bbcostindex',
      'lit' => 'litrate',
      'psef' => 'edf',
      'psem' => 'edm',
      'GDPcap' => 'gdpcapus',
      'pop' => 'pop',
      'rf' => 'rfactor'
    }

    admin_names.each { |k, v|
      DatumSource.find_by_admin_name( k ).update_attributes( admin_name: v ) if DatumSource.exists?( admin_name: k )
    }

    Indicator.in_index( '2015' ).delete_all

    Indicator.in_index( '2014' ).each { |i|
      i2015 = i.dup
      i2015.index_name = '2015'
      i2015.save
    }
  end

  desc 'Seed datum_source attributes: short_name & display_class after 20160420 migration'
  task :seed_short_name_and_display_class => [ :environment ] do |task|
    affixes = [ '%', 'kbps', '$' ]

    DatumSource.all.each { |ds|
      ds.short_name = ds.public_name

      case "#{ds.display_prefix}#{ds.display_suffix}"
      when '%'
        ds.display_class = 'percentage'

      when 'kbps'
        ds.display_class = 'speed'

      when '$'
        ds.display_class = 'currency'

      end

      ds.save
      Rails.logger.info "#{ds.short_name} is a #{ds.display_class}"
    }
  end

  desc 'Create regions'
  task :create_regions => [:environment] do |task, args|
    categories = Category.all
    CSV.open(Rails.root.join('db', 'regions.csv'), {:headers => true}).each do |line|
      region = Country.find_or_initialize_by_iso3_code iso3_code: line['cc3'], name: line['region'], region: true
      region.categories = categories
      region.save!
    end
  end

  desc 'Read all data from IM spreadsheet and store as indicator data in a named access index'
  task :update_access_index, [:index_name, :data_file] => [:environment] do |task, args|
    update_access_index args[ :index_name ], args[ :data_file ]
  end
end

def export_most_recent( filename )
  if filename.to_s == ''
    puts "Usage: rake imon:export_most_recent['output_filename.csv']"
    return
  end

  puts "Exporting to #{filename}"

  countries = Country.with_enough_data.order( :iso3_code )
  puts "#{countries.count} countries"
  
  CSV.open( filename, 'wb' ) { |csv|
    csv << [ 'c_iso3_code', 'c_name', 'ds_public_name', 'ds_admin_name', 'ds_group', 'ds_affects_score', 'ds_min', 'ds_max', 'ds_default_weight', 'd_start_date', 'd_original_value', 'd_value' ]

    count = 0

    countries.each { |c|
      indicators = c.indicators.affecting_score.in_current_index.order { |i| i.source.public_name }
      puts "#{c.name} has #{indicators.count} data values"

      indicators.each { |d|
        ds = d.source
        csv << [ c.iso3_code, c.name, ds.public_name, ds.admin_name, ( ds.group.present? ? ds.group.admin_name : nil ), ds.affects_score, ds.min, ds.max, ds.default_weight, d.start_date, d.original_value, d.value ]

        count += 1
      }
    }

    puts "#{count} data values exported total"
  }
end

def import_country_bboxes( filename )
  if filename.to_s == ''
    puts "Usage: rake imon:import_country_bboxes['db/data_files/country_bbox.json']"
    return
  end

  if !File.exists? filename
    puts "cannot find #{filename}"
    return
  end

  bbox_json = IO.read filename

  if bbox_json.nil?
    puts "error reading #{filename}"
    return
  end

  bboxen = JSON.parse bbox_json

  if bboxen.nil?
    puts "error parsing JSON from #{filename}"
    return
  end

  bboxen.each { |bbox|
    puts "setting #{bbox[0]} to #{bbox[1]}"
    country = Country.find_by_iso3_code bbox[0]
    if country.present?
      country.bbox = bbox[1].to_s
      country.save
    end
  }
end

def mcp_081
    countries_page = Refinery::Page.find_by_slug( 'zzz-countries' ) || Refinery::Page.find_by_slug( 'country-profiles' )

    if countries_page.nil?
      Rails.logger.info '[mcp] cannot find zzz-countries or country-profiles page, exiting'
      return
    end

    countries_page.update_attributes title: 'Country Profiles'

    countries_page.children.each { |cp|
      Rails.logger.info "[mcp] page: #{cp.title}"
      c = Country.find_by_iso3_code( cp.title.upcase ) || Country.find_by_iso3_code( cp.menu_title.upcase )
      sections = %w[Body Access Control Activity]
      if c.present?
        Rails.logger.info "[mcp] country: #{c.name}"
        cp.update_attributes title: c.name, menu_title: c.iso3_code.downcase
        contents = sections.map { |s| "<h2>#{s == 'Body' ? 'Overview' : s}</h2>#{cp.content_for s}" }
        # reduce Body section to first line
        contents[0] = contents[0].lines[0].strip
        new_body = contents.join "\r\n"
        Rails.logger.info "[mcp] new_body: #{new_body}"
        cp.part_with_title( 'Body' ).update_attributes body: new_body
      else
        Rails.logger.info "[mcp] country: nil"
      end
    }
end

def widget_embed( dashboard_host, widget_dsc )
  %{<iframe src="#{dashboard_host}/widgets/#{widget_dsc[ 'mid' ]}/embed?unbranded&seamless&noCountry" width="#{165*widget_dsc[ 'cx' ]}" height="#{165*widget_dsc[ 'cy' ]}" frameborder="0" scrolling="no" data-row="#{widget_dsc[ 'row' ]}" data-col="#{widget_dsc[ 'col' ]}"></iframe>}
end

def import_country_widgets( cp, dashboard_id, widget_dscs )
  dashboard_host = 'https://dashboard.dev.berkmancenter.org'
  dashboard_root = "#{dashboard_host}/dashboards"
  dashboard_url = "#{dashboard_root}/#{dashboard_id}"

  if cp.nil?
    Rails.logger.error "[icw] cp: nil, dashboard_id: #{dashboard_id}"
    return
  end

  Rails.logger.info "[icw] cp: #{cp.slug}, dashboard_id: #{dashboard_id}, widget_count: #{widget_dscs.count}"

  if !dashboard_id.present?
    return
  end

  body = '<div class="widget-row">'
  current_row = 1

  widget_dscs.each { |wdsc|
    if wdsc[ 'row' ] != current_row
      Rails.logger.info "[icw] widget-row wdsc[row]: #{wdsc['row']}, current_row: #{current_row}"
      body += '</div><div class="widget-row">'
      current_row = wdsc[ 'row' ].to_i
    end
    body += "#{widget_embed dashboard_host, wdsc}\r\n"
  }
  body += '</div>'

  Rails.logger.info "[icww] #{body}"

  body_part = cp.part_with_title( 'Body' )
  
  if body_part.nil?
    cp.parts << Refinery::PagePart.new( title: 'Body', body: body )

  else
    body_part.update_attributes body: body
  end
end

def replace_static_source( row_number, iso3_code )
  sources = Roo::Excelx.new Rails.root.join('db', 'sources.xlsx').to_s

  line = CSV.parse( sources.sheet( sources.default_sheet ).to_csv, { :headers => true } )[row_number.to_i - 1]

  if line.nil?
    puts "cannot find source line #{row_number}"
    return
  end

  ds = DatumSource.find_by_admin_name line[ 'Short name' ]
  if ds.nil?
    puts "cannot find DatumSource #{line[ 'Short name' ]}"
    return
  end

  country = Country.find_by_iso3_code iso3_code
  if country.nil?
    puts "cannot find Country #{iso3_code}"
    return
  end

  datum = Datum.where( { datum_source_id: ds.id, country_id: country.id } ).order( 'start_date desc' ).limit( 1 )
  if datum.count == 0
    puts "cannot find existing datum"
    return
  end

  datum = datum.first

  puts "Replacing #{ds.public_name} for #{country.name} (datum.id #{datum.id})"

  Retriever.retrieve!( row_number, datum )
end


def update_access_index( index_name, data_file )
  Rails.logger.info "update_access_index #{index_name}, #{data_file}"

  index_indicators = {
    '2014' => %w[ipr_2013 hhnet_2013 bbsub_2013 mobilebb_2013 rfactor_2014 bbrate_2014 highbbrate_2014 speedkbps_2014 peakspeedkbps_2014 downloadkbps_2014 uploadkbps_2014 bbcost1_2014 bbcost2_2014 bbcost3_2014 bbcost4_2014 bbcost5_2014 bbcostindex_2014 litrate_2014 edf_2014 edm_2014 gdpcapus_2013 pop_2013],
    '2015' => %w[ipr_2014 hhnet_2014 bbsub_2014 mobilebb_2014 rfactor_2015 bbrate_2015 highbbrate_2015 speedkbps_2015 peakspeedkbps_2015 downloadkbps_2015 uploadkbps_2015 bbcost1_2015 bbcost2_2015 bbcost3_2015 bbcost4_2015 bbcost5_2015 bbcostindex_2015 litrate_2015 edf_2015 edm_2015 gdpcapus_2014 pop_2014]
  }

  if index_name.nil? || index_indicators[ index_name ].nil?
    Rails.logger.error 'update_access_index: invalid index_name'
    return
  end

  if data_file.nil? || !File.exists?( data_file )
    Rails.logger.error "update_access_index: cannot open data_file: #{data_file}"
    return
  end

  ds_cols = index_indicators[ index_name ]

  data_text = IO.read( data_file ).encode( invalid: :replace, undef: :replace, replace: '?' )

  CSV.parse( data_text, { :headers => true } ).each do |row|
    begin
      # unscoped to include regions
      c = Country.unscoped.find_by_iso3_code row['cc3'].upcase

      if c.nil?
        Rails.logger.error "update_access_index: cannot find country #{row['cc3']}"
        next
      end

      ds_cols.each { |ds_col| 
        ds_parts = ds_col.split('_')

        ds = DatumSource.find_by_admin_name ds_parts[0]
        datum_date = "#{ds_parts[1]}-12-31".to_date

        is = Indicator.where datum_source_id: ds.id, index_name: index_name, country_id: c.id
        indicator = nil

        if is.any?
          if row[ds_col].blank?
            is.delete_all
          else
            Rails.logger.info "update_access_index: indicator.update_attributes original_value: #{row[ds_col].to_f}"
            indicator = is.first
            indicator.original_value = row[ds_col].to_f * ds.multiplier
            indicator.start_date = datum_date
          end
        else
          if !row[ds_col].blank?
            Rails.logger.info "update_access_index: Indicator.create datum_source: #{ds.admin_name}, start_date: #{datum_date}, country: #{c.iso3_code}, original_value: #{row[ds_col].to_f}"
            indicator = Indicator.new datum_source_id: ds.id, index_name: index_name, start_date: datum_date, country_id: c.id, original_value: ( row[ds_col].to_f * ds.multiplier )
          end
        end

        if !indicator.nil?
          if ds.normalized
            if ds.normalized_name.present?
              normalized_col = "#{ds.normalized_name}_#{ds_parts[1]}"
              indicator.value = row[normalized_col].to_f
            else
              indicator.value = indicator.original_value
            end
            indicator.value = 1 - indicator.value if ds.invert
          end
          indicator.save!
        end
      }
    rescue Exception => e
      Rails.logger.error "update_access_index: error importing index data: #{row}"
      Rails.logger.error e.inspect
    end

  end

  Country.count_indicators!( index_name )
  DatumSource.recalc_min_max_and_values!( index_name )
  Country.calculate_scores_and_rank!( index_name )

  Region.count_indicators!( index_name )
  Region.calculate_scores_and_rank!( index_name )
end
