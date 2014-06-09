# Export/import refinery pages

namespace :refinery_pages do
  desc 'Reset refinerycms pages, leaves only Home, About, & Blog'
  task :reset => [:environment] do |task|
    Refinery::Page.delete_all 'not id in (1,2,3,4)'
  end

  desc 'Export refinerycms pages as JSON'
  task :export, [ :path ] => [:environment] do |task, args|
    refinery_pages_export args[ :path ]
  end

  def refinery_pages_export( path )
    usage = "usage: refinery_pages:export['path/to/filename.json']"

    if path.nil?
      puts usage
      return
    end

    File.open( path , 'w' ) { |f|
      f.write( Refinery::Page.all.to_json( include: :parts ) )
    }
  end

  desc 'Import exported refinerycms pages from JSON'
  task :import, [ :path ] => [:environment] do |task, args|
    refinery_pages_import args[ :path ]
  end

  def refinery_pages_import( path )
    usage = "usage: refinery_pages:import['path/to/filename.json']"

    if path.nil?
      puts usage
      return
    end

    if !File.exists? path
      puts "cannot find #{path}"
      return
    end

    pages_json = IO.read path

    if pages_json.nil?
      puts "error reading #{path}"
      return
    end

    pages = JSON.parse pages_json

    if pages.nil?
      puts "error parsing JSON from #{path}"
      return
    end

    puts "importing #{pages.count} page(s)"

    id_map = {}

    pages.each { |page|
      # grab all top-level pages first to get their ids
      next unless page[ 'parent_id' ].nil?
      page_id = import_page page, id_map
      id_map[ page[ 'id' ] ] = page_id
    }

    pages.each { |page|
      # grab the rest (child pages)
      next unless page[ 'parent_id' ].present?
      page_id = import_page page, id_map
      id_map[ page[ 'id' ] ] = page_id
    }

    # known issue: this script will not import pages three levels deep
  end

  def import_page( page, id_map )
    # imports a page, returns its new id
    puts "importing #{page[ 'title' ]} (slug: #{page[ 'slug' ]}) & #{page[ 'parts' ].count} part(s)"

    page_rec = Refinery::Page.find_by_title page[ 'title' ]

    if page_rec.nil?
      page_rec = Refinery::Page.create title: page[ 'title' ]

      if page[ 'parent_id' ].present?
        puts "  child page of (id: #{id_map[ page[ 'parent_id' ] ]}, prev_id: #{page[ 'parent_id' ]})"
        page_rec.parent_id = id_map[ page[ 'parent_id' ] ]
        page_rec.save
      end

      page_rec.slug = page[ 'slug' ]
      page_rec.show_in_menu = page[ 'show_in_menu' ]
      page_rec.deletable = page[ 'deletable' ]
      page_rec.draft = page[ 'draft' ]
      page_rec.link_url = page[ 'link_url' ]
      page_rec.save

      puts "  #{page_rec.slug} is a new page (id: #{page_rec.id}, prev_id: #{page[ 'id' ]})"
    end

    page[ 'parts' ].each_with_index { |part, i|
      puts "  importing part #{i} #{part[ 'title' ]}"

      part_rec = page_rec.parts.find_or_create_by_title part[ 'title' ]
      part_rec.body = part[ 'body' ]
      part_rec.position = part[ 'position' ]
      part_rec.save
    }

    page_rec.id
  end

end
